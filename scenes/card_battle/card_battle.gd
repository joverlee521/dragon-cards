class_name CardBattle
extends Node
## The root scene for the card battle

## The player's [Character] resource
@export var player: Character = Character.new()
## Flag to init [member CardBattle.player] character stats on ready
@export var init_player_stats: bool = false


func _ready() -> void:
	if init_player_stats:
		player.init_stats()
	start_battle()


## Sets the scene to start of battle
func start_battle() -> void:
	_connect_player_stats_signals()
	_update_player_health_label()
	_update_player_defense_label()


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
