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
	_update_player_stats_labels()


## Updates the text of player stats labels
func _update_player_stats_labels() -> void:
	$PlayerStats/Health.text = "%s / %s" % [str(player._health), str(player.vocation.max_health)]
	$PlayerStats/Defense.text = str(player._defense)
