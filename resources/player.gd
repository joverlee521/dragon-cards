class_name Player extends Resource


var character: Character

@export var vocation: Vocation
@export var cards: = [] # Array[CardAttributes]


func _init(i_vocation: Vocation, i_cards): # i_cards: Array[CardAttributes]
	vocation = i_vocation
	cards = i_cards
	character = Character.new(vocation.max_health, 0, func(): pass)


func set_player_stats_label_function(set_player_stats_label: Callable):
	character.set_stat_display = set_player_stats_label
