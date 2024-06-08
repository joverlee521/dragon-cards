class_name CardBattle
extends Node
## The root scene for the card battle

#region Signals ##########################################################################################

## Emitted whenever the player exits the card battle
signal exit_card_battle(exit_status: EXIT_STATUS, player: Character)

#endregion
#region Enums ############################################################################################

## Player's exit status of the card battle
enum EXIT_STATUS {WIN, LOSE}

#endregion
#region Constants ########################################################################################


#endregion
#region @export variables ################################################################################

@export_group("Action Timers and Scale")
## Time delayed at the start of the battle before the first hand is dealt
@export var START_BATTLE_DELAY: float = 0.5
## Time delayed between each card that is dealt
@export var DEAL_CARD_DELAY: float = 0.3
## Time delayed between each card that is played
@export var PLAYED_CARD_DELAY: float = 0.7
## Final scale of played card
@export var PLAYED_CARD_SCALE: Vector2 = Vector2(1.3, 1.3)
## Time delayed between each card that is discarded
@export var DISCARD_CARD_DELAY: float = 0

@export_group("Battle Setup")
## The player's [Character] resource
@export var player: Character = Character.new()
## Flag to init [member CardBattle.player] character stats on ready
@export var init_player_stats: bool = false
## The [Card] to instantiate for cards in battle
@export var card_scene: PackedScene = load("res://scenes/card_battle/card.tscn")
## The [Enemy]s to fight in card battle
@export var enemies: Array[PackedScene] = [] # Array[Enemy]

#endregion
#region Public variables #################################################################################


#endregion
#region Private variables ################################################################################


#endregion
#region @onready variables ###############################################################################


#endregion
#region Optional _init method ############################################################################


#endregion
#region Optional _enter_tree() method ####################################################################


#endregion
#region Optional _ready method ###########################################################################

func _ready() -> void:
	_connect_player_stats_signals()
	if init_player_stats:
		player.init_stats()
	start_battle()

#endregion
#region Optional remaining built-in virtual methods ######################################################


#endregion
#region Public methods ###################################################################################

func start_battle() -> void:
	$EndBattleCanvas.hide()
	$PlayerSprite.texture = player.vocation.vocation_sprite
	_update_player_health_label()
	_update_player_defense_label()
	_update_player_stamina_label()
	player.cards.map($PlayDeck.add_card)
	$PlayDeck.shuffle()
	await get_tree().create_timer(START_BATTLE_DELAY).timeout
	$EnemyManager.instantiate_enemies(enemies)
	start_player_turn()


func start_player_turn() -> void:
	if $PlayDeck.is_empty():
		refresh_play_deck_from_discard()
		# TODO: Add display for skipping player's turn
		start_enemies_turn()
		return
	$PlayerControls/PlayCard.disabled = true
	$PlayerControls/EndTurn.disabled = false
	$PlayerHand.reset_stamina(player.vocation.max_stamina)
	deal_cards(player.vocation.max_hand_size)


## Deal [param num] cards from the [PlayDeck] to the [PlayerHand]
func deal_cards(num: int) -> void:
	for i in range(num):
		if $PlayDeck.is_empty():
			break

		var card_attributes: CardAttributes = $PlayDeck.remove_card()
		var new_card: Card = card_scene.instantiate()
		new_card.card_attributes = card_attributes
		$PlayerHand.add_card(new_card)
		# TODO: Replace timer with animations
		await get_tree().create_timer(DEAL_CARD_DELAY).timeout


## Discard [Card] by adding to the DiscardDeck
func discard_card(card: Card) -> void:
	if card.get_parent() == self:
		remove_child(card)
	$DiscardDeck.add_card(card.card_attributes.duplicate(true))
	card.queue_free()


func refresh_play_deck_from_discard() -> void:
	$DiscardDeck.remove_all_cards().map($PlayDeck.add_card)
	$PlayDeck.shuffle()


func start_enemies_turn() -> void:
	$PlayerControls/PlayCard.disabled = true
	$PlayerControls/EndTurn.disabled = true
	$PlayerHand.set_cards_clickable(false)

	for enemy: Enemy in $EnemyManager.get_all_enemies():
		await _play_enemy_card(enemy)

	get_tree().call_group($EnemyManager.ENEMIES_IN_BATTLE, "pick_next_card")
	start_player_turn()

#endregion
#region Private methods ##################################################################################


## Stops all processes and emits signal to exit card battle
## The [param _exit_status] represents whether the player won or lost the card battle
func _exit_card_battle(_exit_status: EXIT_STATUS) -> void:
	get_tree().paused = true
	player.remove_all_defense()

	var end_battle_status_text := ""
	match _exit_status:
		EXIT_STATUS.WIN:
			end_battle_status_text = "YOU WIN!"
		EXIT_STATUS.LOSE:
			end_battle_status_text = "YOU LOSE!"
		_:
			assert(false, "Encountered unsupported EXIT_STATUS %s" % _exit_status)

	$EndBattleCanvas/EndBattleContainer/EndBattleStatus.text = end_battle_status_text
	$EndBattleCanvas.show()

	exit_card_battle.emit(_exit_status, player)


## Connects the player's emitted stats signals to the label updates
func _connect_player_stats_signals() -> void:
	player.health_depleted.connect(_on_player_death)
	player.health_changed.connect(_update_player_health_label)
	player.defense_changed.connect(_update_player_defense_label)


func _on_player_death() -> void:
	_exit_card_battle(EXIT_STATUS.LOSE)


func _update_player_health_label(player_health: int = player._health) -> void:
	$PlayerStats/Health.text = "%s / %s" % [str(player_health), str(player.vocation.max_health)]


func _update_player_defense_label(player_defense: int = player._defense) -> void:
	$PlayerStats/Defense.text = str(player_defense)


func _update_player_stamina_label(player_stamina: int = player.vocation.max_stamina) -> void:
	$PlayerStats/Stamina.text = "%s / %s" % [str(player_stamina), str(player.vocation.max_stamina)]


func _player_hand_card_selection_changed(selected_cards_playable: bool) -> void:
	$PlayerControls/PlayCard.disabled = !selected_cards_playable


func _play_card(card: Card, card_affectees: CardAttributes.CardAffectees) -> void:
	var card_env := CardAttributes.CardEnvironment.new($PlayDeck, $DiscardDeck)
	add_child(card)
	card.position = $PlayedCard.position
	card.play(card_affectees, card_env)
	await card.run_scale_animation(PLAYED_CARD_SCALE, PLAYED_CARD_DELAY)


func _on_play_card_pressed() -> void:
	$PlayerControls/EndTurn.disabled = true
	var card: Card = $PlayerHand.play_selected_card()
	await _play_card(card, _create_player_owner_card_affectees())
	discard_card(card)
	$PlayerHand.set_cards_clickable(true)
	$PlayerControls/EndTurn.disabled = false


func _on_end_turn_pressed() -> void:
	for card: Card in $PlayerHand.discard_all_cards():
		discard_card(card)
		await get_tree().create_timer(DISCARD_CARD_DELAY).timeout
	start_enemies_turn()


func _play_enemy_card(enemy: Enemy) -> void:
	var card: Card = card_scene.instantiate()
	var card_attributes: CardAttributes = enemy.get_next_card()
	card.card_attributes = card_attributes
	card.set_clickable(false)
	await _play_card(card, _create_enemy_owner_card_affectees(enemy))
	card.queue_free()


func _create_player_owner_card_affectees() -> CardAttributes.CardAffectees:
	var card_owner:= CardAttributes.CardTarget.new(player, $PlayerSprite.global_position)
	var owner_team: Array[CardAttributes.CardTarget] = []

	var selected_enemy: Enemy = $EnemyManager.get_selected_enemy()
	var opposer: = selected_enemy.create_card_target()
	var opposer_team: Array[CardAttributes.CardTarget] = $EnemyManager.get_all_other_enemies_as_card_targets(selected_enemy)
	return CardAttributes.CardAffectees.new(card_owner, owner_team, opposer, opposer_team)


func _create_enemy_owner_card_affectees(enemy_owner: Enemy) -> CardAttributes.CardAffectees:
	var card_owner := enemy_owner.create_card_target()
	var owner_team: Array[CardAttributes.CardTarget] = $EnemyManager.get_all_other_enemies_as_card_targets(enemy_owner)

	var opposer: = CardAttributes.CardTarget.new(player, $PlayerSprite.global_position)
	var opposer_team: Array[CardAttributes.CardTarget] = []
	return CardAttributes.CardAffectees.new(card_owner, owner_team, opposer, opposer_team)

#endregion
#region Subclasses #######################################################################################s


#endregion
