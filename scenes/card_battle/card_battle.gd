class_name CardBattle
extends Node
## The root scene for the card battle

## Time delayed at the start of the battle before the first hand is dealt
const START_BATTLE_DELAY: float = 0.5
## Time delayed between each card that is dealt
const DEAL_CARD_DELAY: float = 0.3

## The player's [Character] resource
@export var player: Character = Character.new()
## Flag to init [member CardBattle.player] character stats on ready
@export var init_player_stats: bool = false
## The [Card] to instantiate for cards in battle
@export var card_scene: PackedScene = load("res://scenes/card_battle/card.tscn")


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
	start_player_turn()


## Starts the player turn by
## [br] 1. Setting the player hand with max stamina
## [br] 2. Dealling a full hand of [Card]s
func start_player_turn() -> void:
	$PlayerHand.reset_stamina(player.vocation.max_stamina)
	deal_cards(player.vocation.max_hand_size)


## Deal [param num] cards from the [PlayDeck] to the [PlayerHand]
func deal_cards(num: int) -> void:
	for i in range(num):
		if $PlayDeck.is_empty():
			break

		var card_attributes = $PlayDeck.remove_card()
		var new_card: Card = card_scene.instantiate()
		new_card.card_attributes = card_attributes
		$PlayerHand.add_card(new_card)
		# TODO: Replace timer with animations
		await get_tree().create_timer(DEAL_CARD_DELAY).timeout


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
