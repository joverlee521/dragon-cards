class_name Character extends RefCounted

var defense: int
var max_health: int
var health: int
var set_stat_display: Callable
var card_battle_position: Vector2


func _init(i_max_health: int, i_defense: int, i_set_stat_display: Callable) -> void:
	max_health = i_max_health
	health = max_health
	defense = i_defense
	set_stat_display = i_set_stat_display


func add_defense(num: int) -> void:
	defense += num
	set_stat_display.call()


func remove_all_defense() -> void:
	defense = 0
	set_stat_display.call()


func add_health(num: int) -> void:
	health += num
	if health > max_health:
		health = max_health
	set_stat_display.call()



func remove_health(num: int) -> void:
	if num >= defense:
		num -= defense
		defense = 0
	else:
		defense -= num
		num = 0

	health -= num
	set_stat_display.call()
	
func remove_health_directly(num: int) -> void:
	health -= num
	set_stat_display.call()	
	
func set_card_battle_position(i_position: Vector2) -> void:
	card_battle_position = i_position
