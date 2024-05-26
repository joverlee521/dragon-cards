class_name Character
extends Resource
## Base resource for storing and calculating character stats

# Signals ##########################################################################################

## Emitted whenever [memeber Character._health] changes in value
signal health_changed(new_value: int)
## Emitted whenever [member Character._defense] changes in value
signal defense_changed(new_value: int)

# Enums ############################################################################################



# Constants ########################################################################################



# @export variables ################################################################################

## Character's vocation with basic stats
@export var vocation: Vocation = Vocation.new()
## [CardAttributes] the [Character] has equipped.
## TODO: Replace with items that contains their own cards
@export var cards: Array[CardAttributes] = []

# Public variables #################################################################################



# Private variables ################################################################################

## Character's current defense
var _defense: int = 0:
	set = _set_defense

## Character's current health
var _health: int = 0:
	set = _set_health


# @onready variables ###############################################################################



# Optional _init method ############################################################################

# Here for testing purposes
func _init(i_vocation: Vocation = Vocation.new(),
		   i_cards: Array[CardAttributes] = []) -> void:

	vocation = i_vocation
	cards = i_cards
	init_stats()


# Optional _enter_tree() method ####################################################################



# Optional _ready method ###########################################################################



# Optional remaining built-in virtual methods ######################################################



# Public methods ###################################################################################

## Initialize the following stats: [br]
## 1. [member Character._health] to [member Vocation.max_health]
## 2. [member Character._defense] to [member Vocation.starting_defense]
## 3. If [member Character.cards] is empty, then use [member Vocation.cards]
func init_stats() -> void:
	_health = vocation.max_health
	_defense = vocation.starting_defense
	if cards.is_empty():
		cards = vocation.cards.duplicate(true)


func remove_all_defense() -> void:
	_defense = 0


func add_defense(num: int) -> void:
	_defense += num


func add_health(num: int) -> void:
	_health += num


## Subtract [param damage] from [member Character._defense] and if there
## is remaining damage, then subtract from [member Character._health]
## Subtracts directly from [member Character._health] if [param ignore_defense]
## is set to true.
func take_damage(damage: int, ignore_defense: bool = false) -> void:
	if not ignore_defense:
		if damage > _defense:
			damage -= _defense
			_defense = 0
		else:
			_defense -= damage
			damage = 0

	_health -= damage


# Private methods ##################################################################################

func _set_defense(value: int) -> void:
	_defense = value
	defense_changed.emit(_defense)


func _set_health(value: int) -> void:
	_health = value
	health_changed.emit(value)


# Subclasses #######################################################################################
