class_name Character extends Resource

@export_group("Character Stats")
@export var max_health: int = 0
@export var defense: int = 0

var health: int
var card_battle_position: Vector2


func _init(i_max_health: int = 0, i_defense: int = 0):
	max_health = i_max_health
	defense = i_defense


func init_health():
	health = max_health


func add_defense(num: int) -> void:
	defense += num


func remove_all_defense() -> void:
	defense = 0


func add_health(num: int) -> void:
	health += num
	if health > max_health:
		health = max_health


func remove_defense_then_health(num: int) -> void:
	if num >= defense:
		num -= defense
		defense = 0
	else:
		defense -= num
		num = 0

	health -= num

func remove_health_directly(num: int) -> void:
	health -= num

func set_card_battle_position(i_position: Vector2) -> void:
	card_battle_position = i_position
