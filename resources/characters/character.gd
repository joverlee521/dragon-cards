class_name Character
extends Resource
## Base resource for storing and calculating character stats

#region Signals ##########################################################################################

## Emitted whenever [memeber Character._health] changes in value
signal health_changed(new_value: int)
## Emitted whenever [member Character._defense] changes in value
signal defense_changed(new_value: int)

#endregion
#region Enums ############################################################################################


#endregion
#region Constants ########################################################################################


#endregion
#region @export variables ################################################################################

## Character's vocation with basic stats
@export var vocation: Vocation = Vocation.new()
## [CardAttributes] the [Character] has equipped.
## TODO: Replace with items that contains their own cards
@export var cards: Array[CardAttributes] = []

#endregion
#region Public variables #################################################################################


#endregion
#region Private variables ################################################################################

## Character's current defense
var _defense: int = 0:
	set = _set_defense

## Character's current health
var _health: int = 0:
	set = _set_health

#endregion
#region @onready variables ###############################################################################


#endregion
#region Optional _init method ############################################################################

# Here for testing purposes
func _init(i_vocation: Vocation = Vocation.new(),
		   i_cards: Array[CardAttributes] = []) -> void:

	vocation = i_vocation
	cards = i_cards
	init_stats()

#endregion
#region Optional _enter_tree() method ####################################################################


#endregion
#region Optional _ready method ###########################################################################


#endregion
#region Optional remaining built-in virtual methods ######################################################


#endregion
#region Public methods ###################################################################################

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


## Reduce [member Character._defense] and/or [member Character._health]
##
## Uses [param base_attack] and [param damage_element] to calculate the total damage.
## Subtract damage from [member Character._defense] and if there
## is remaining damage, then subtract from [member Character._health]
## Subtract damage directly from [member Character._health] if [param ignore_defense]
## is set to true.
func take_damage(base_attack: int,
				 damage_element: Weapon.DAMAGE_ELEMENT,
				 ignore_defense: bool = false) -> void:
	var damage: int = _calculate_damage(base_attack, damage_element)
	if not ignore_defense:
		if damage > _defense:
			damage -= _defense
			_defense = 0
		else:
			_defense -= damage
			damage = 0

	_health -= damage

#endregion
#region Private methods ##################################################################################

## Calculate the total damage using [param base_attack] and [param damage_element]
##
## If the [param damage_element] is in [member Vocation.damage_element_resistances], half the damage
## If the [param damage_element] is in [member Vocation.damage_element_weaknesses], double the damage
func _calculate_damage(base_attack: int, damage_element: Weapon.DAMAGE_ELEMENT) -> int:
	var damage: float = base_attack

	if damage_element in vocation.damage_element_resistances:
		damage = damage * 0.5

	if damage_element in vocation.damage_element_weaknesses:
		damage = damage * 2

	return ceil(damage)


func _set_defense(value: int) -> void:
	_defense = value
	if _defense < 0:
		_defense = 0
	defense_changed.emit(_defense)


func _set_health(value: int) -> void:
	_health = value
	if _health < 0:
		_health = 0
	health_changed.emit(_health)

#endregion
#region Subclasses #######################################################################################


#endregion
