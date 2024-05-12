## Base resource for storing and calculating character stats
extends Resource
class_name Character

@export_group("Character Stats")
## Max health and the default health if you run [method Character.init_health]
@export var max_health: int = 0
## Default defense
@export var defense: int = 0
## Resistances that reduce incoming attack damage of [member Weapon.DAMAGE_TYPE]
@export var resistances: Array[Weapon.DAMAGE_TYPE]
## Weaknesses that increases incoming attack damage of [member Weapon.DAMAGE_TYPE]
@export var weaknesses: Array[Weapon.DAMAGE_TYPE]

## Current health
var health: int = 0
## Global position within the [CardBattle]
var card_battle_position: Vector2 = Vector2(0,0)

## Initialize [member Character.health] to the [member Character.max_health]
func init_health() -> void:
	health = max_health

## Adds [param num] to the [member Character.defense]
func add_defense(num: int) -> void:
	defense += num

## Sets [member Character.defense] to [code]0[/code]
func remove_all_defense() -> void:
	defense = 0

## Adds [param num] to the [member Character.health].
##
## [br]NOTE: [member Character.health] maxes out at [member Character.max_health]
func add_health(num: int) -> void:
	health += num
	if health > max_health:
		health = max_health

## Subtracts [param num] from [member Character.defense] then from [member Character.health]
func remove_defense_then_health(num: int) -> void:
	defense -= num
	if defense < 0:
		var health_damage: int = abs(defense)
		health -= health_damage
		defense = 0

## Ignores [member Character.defense] and subtracts [param num] from [member Character.health]
func remove_health_directly(num: int) -> void:
	health -= num

## Calculates the actual damage number based the base [param num] and the [param damage_types].
##
## [br]Doubles damage if any of [param damage_types] is in [member Character.weaknesses].
## [br]Halves damage if any of [param damage_types] is in [member Character.resistances].
func calculate_damage_num_by_damage_type(num: int, damage_types: Array[Weapon.DAMAGE_TYPE] = [Weapon.DAMAGE_TYPE.DEFAULT]) -> int:
	var damage_num: int = num
	if Helper.arrays_intersect(weaknesses, damage_types):
		damage_num = num * 2
	elif Helper.arrays_intersect(resistances, damage_types):
		damage_num = num / 2
	return damage_num

## Sets [member Character.card_battle_position] to [param position]
func set_card_battle_position(position: Vector2) -> void:
	card_battle_position = position
