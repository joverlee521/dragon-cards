class_name PlayerVocation
extends Vocation
## Base resource for storing player stats

#region Signals ##########################################################################################


#endregion
#region Enums ############################################################################################


#endregion
#region Constants ########################################################################################


#endregion
#region @export variables ################################################################################

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

#endregion
#region Public variables #################################################################################


#endregion
#region Private variables ################################################################################


#endregion
#region @onready variables ###############################################################################


#endregion
#region Optional _init method ############################################################################


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
