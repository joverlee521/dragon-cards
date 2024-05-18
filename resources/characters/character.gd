class_name Character
extends Resource
## Base resource for storing and calculating character stats

## Emitted whenever [memeber Character.health] changes in value
signal health_changed(new_value: int)
## Emitted whenever [member Character.defense] changes in value
signal defense_changed(new_value: int)

## Character's vocation with basic stats
@export var vocation: Vocation
## [CardAttributes] the [Character] has equipped.
## TODO: Replace with items that contains their own cards
@export var cards: Array[CardAttributes] = []

## Character's current defense
var defense: int = 0:
	set(num):
		defense = num
		defense_changed.emit(num)
## Character's current health
var health: int = 0:
	set(val):
		health = val
		health_changed.emit(val)


## Initialize the following stats: [br]
## 1. [member Character.health] to [member Vocation.max_health]
## 2. [member Character.defense] to [member Vocation.starting_defense]
## 3. If [member Character.cards] is empty, then use [member Vocation.cards]
func init_character_stats() -> void:
	health = vocation.max_health
	defense = vocation.starting_defense
	if cards.is_empty():
		cards = vocation.cards.duplicate(true)


func remove_all_defense() -> void:
	defense = 0


func add_defense(num: int) -> void:
	defense += num


func add_health(num: int) -> void:
	health += num


## Subtract [param damage] from [member Character.defense] and if there
## is remaining damage, then subtract from [member Character.health]
## Subtracts directly from [member Character.health] if [param ignore_defense]
## is set to true.
func take_damage(damage: int, ignore_defense: bool = false) -> void:
	if not ignore_defense:
		if damage > defense:
			damage -= defense
			defense = 0
		else:
			defense -= damage
			damage = 0

	health -= damage
