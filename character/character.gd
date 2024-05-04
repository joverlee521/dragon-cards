class_name Character extends RefCounted

var defense: int
var max_health: int
var health: int



func _init(i_max_health: int, i_defense: int) -> void:
	max_health = i_max_health
	health = max_health
	defense = i_defense


func add_defense(num: int) -> void:
	defense += num


func add_health(num: int) -> void:
	health += num


func remove_health(num: int) -> void:
	if num >= defense:
		num -= defense
		defense = 0
	else:
		defense -= num
		num = 0

	health -= num
