class_name CardBattle
extends Node
## The root scene for the card battle

## Time delayed at the start of the battle before the first hand is dealt
const START_BATTLE_DELAY: float = 0.5
## Time delayed between each card that is dealt
const DEAL_CARD_DELAY: float = 0.3
## Time delayed between each card that is played
const PLAYED_CARD_DELAY: float = 0.7
## Final scale of played card
const PLAYED_CARD_SCALE: Vector2 = Vector2(1.3, 1.3)
## Time delayed between each card that is discarded
const DISCARD_CARD_DELAY: float = 0


## The player's [Character] resource
@export var player: Character = Character.new()
## Flag to init [member CardBattle.player] character stats on ready
@export var init_player_stats: bool = false
## The [Card] to instantiate for cards in battle
@export var card_scene: PackedScene = load("res://scenes/card_battle/card.tscn")
## The [Enemy]s to fight in card battle
@export var enemies: Array[PackedScene] = [] # Array[Enemy]


func _ready() -> void:
	_connect_player_stats_signals()
	if init_player_stats:
		player.init_stats()
	start_battle()


## Sets the scene to start of battle
func start_battle() -> void:
	_update_player_health_label()
	_update_player_defense_label()
	_update_player_stamina_label()
	player.cards.map($PlayDeck.add_card)
	await get_tree().create_timer(START_BATTLE_DELAY).timeout
	$EnemyManager.instantiate_enemies(enemies)
	start_player_turn()


## Starts the player turn by
## [br] 1. Setting the player hand with max stamina
## [br] 2. Dealling a full hand of [Card]s
## [br] 3. Disabling the PlayCard button
func start_player_turn() -> void:
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


func discard_card(card: Card) -> void:
	remove_child(card)
	$DiscardDeck.add_card(card.card_attributes.duplicate(true))
	card.queue_free()


func start_enemies_turn() -> void:
	$PlayerControls/PlayCard.disabled = true
	$PlayerControls/EndTurn.disabled = true
	$PlayerHand.set_cards_clickable(false)
	for enemy in get_tree().get_nodes_in_group($EnemyManager.ENEMIES_IN_BATTLE):
		await _play_enemy_card(enemy.use_next_card())
	start_player_turn()


## Connects the player's emitted stats signals to the label updates
func _connect_player_stats_signals() -> void:
	player.health_changed.connect(_update_player_health_label)
	player.defense_changed.connect(_update_player_defense_label)


## Updates the text of player's health label
func _update_player_health_label(player_health: int = player._health) -> void:
	$PlayerStats/Health.text = "%s / %s" % [str(player_health), str(player.vocation.max_health)]


## Updates the text of the player's defense label
func _update_player_defense_label(player_defense: int = player._defense) -> void:
	$PlayerStats/Defense.text = str(player_defense)


## Updates the text of the player's stamina label
func _update_player_stamina_label(player_stamina: int = player.vocation.max_stamina) -> void:
	$PlayerStats/Stamina.text = "%s / %s" % [str(player_stamina), str(player.vocation.max_stamina)]


func _player_hand_card_selection_changed(selected_cards_playable: bool) -> void:
	$PlayerControls/PlayCard.disabled = !selected_cards_playable


func _play_card(card: Card) -> void:
	add_child(card)
	card.position = $PlayedCard.position
	# TODO: Run card effects
	await card.run_scale_animation(PLAYED_CARD_SCALE, PLAYED_CARD_DELAY)


func _on_play_card_pressed() -> void:
	var played_cards: Array[Card] = $PlayerHand.play_selected_cards()
	for card in played_cards:
		await _play_card(card)
		discard_card(card)
	$PlayerHand.set_cards_clickable(true)


func _on_end_turn_pressed() -> void:
	for card: Card in $PlayerHand.discard_all_cards():
		discard_card(card)
		await get_tree().create_timer(DISCARD_CARD_DELAY).timeout
	start_enemies_turn()


func _play_enemy_card(card_attributes: CardAttributes) -> void:
	var card: Card = card_scene.instantiate()
	card.card_attributes = card_attributes
	card.set_clickable(false)
	await _play_card(card)
	card.queue_free()
