class_name Vocation
extends Resource
## Base resource for storing and vocation stats

#region Signals ##########################################################################################


#endregion
#region Enums ############################################################################################


#endregion
#region Constants ########################################################################################


#endregion
#region @export variables ################################################################################

@export_group("Vocation Visual")
## Displayed vocation name
@export var vocation_name: String = ""
## Displayed vocation sprite
@export var vocation_sprite: AtlasTexture = AtlasTexture.new()

@export_group("Vocation Stats")
## Vocation's max health
@export var max_health: int = 0
## Vocation's starting defense
@export var starting_defense: int = 0
## Resistances that reduce incoming attack damage of [member Weapon.DAMAGE_ELEMENT]
@export var damage_element_resistances: Array[Weapon.DAMAGE_ELEMENT] = []
## Weaknesses that increases incoming attack damage of [member Weapon.DAMAGE_ELEMENT]
@export var damage_element_weaknesses: Array[Weapon.DAMAGE_ELEMENT] = []

@export_group("Default Items")
## Default [CardAttributes] the [Vocation] has equipped.
## TODO: Replace with items that contains their own cards
@export var cards: Array[CardAttributes] = []

#endregion
#region Public variables #################################################################################


#endregion
#region Private variables ################################################################################


#endregion
#region @onready variables ###############################################################################


#endregion
#region Optional _init method ############################################################################

# Here for testing purposes
func _init(
			i_max_health: int = 0,
			i_starting_defense: int = 0,
			i_damage_element_resistances: Array[Weapon.DAMAGE_ELEMENT] = [],
			i_damage_element_weaknesses: Array[Weapon.DAMAGE_ELEMENT] = [],
			i_cards: Array[CardAttributes] = []
	) -> void:
	max_health = i_max_health
	starting_defense = i_starting_defense
	damage_element_resistances = i_damage_element_resistances
	damage_element_weaknesses = i_damage_element_weaknesses
	cards = i_cards

#endregion
#region Optional _enter_tree() method ####################################################################


#endregion
#region Optional _ready method ###########################################################################


#endregion
#region Optional remaining built-in virtual methods ######################################################


#endregion
#region Public methods ###################################################################################


#endregion
#region Private methods ##################################################################################


#endregion
#region Subclasses #######################################################################################


#endregion
