class_name PlayerVocation
extends Vocation
## Base resource for storing player stats

# Signals ##########################################################################################



# Enums ############################################################################################



# Constants ########################################################################################



# @export variables ################################################################################

@export_group("Player Stats")
## Max stamina per turn in card battles
@export var max_stamina: int = 0
## Max hand size per turn in card battles
@export var max_hand_size: int = 0

@export_group("Equipment Types")
## [member Armor.ARMOUR_CLASS] allowed to be equipped
@export var armor_types: Array[Armor.ARMOR_CLASS]
## [member Weapon.WEAPON_CLASS] allowed to be equipped to the right hand
@export var right_hand_weapon_types: Array[Weapon.WEAPON_CLASS]
## [member Weapon.WEAPON_CLASS] allowed to be equipped to the left hand
@export var left_hand_weapon_types: Array[Weapon.WEAPON_CLASS]

# Public variables #################################################################################



# Private variables ################################################################################



# @onready variables ###############################################################################



# Optional _init method ############################################################################



# Optional _enter_tree() method ####################################################################



# Optional _ready method ###########################################################################



# Optional remaining built-in virtual methods ######################################################



# Public methods ###################################################################################



# Private methods ##################################################################################



# Subclasses #######################################################################################
