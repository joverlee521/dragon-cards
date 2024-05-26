class_name Weapon
extends Item
## Base resource for storing weapon stats

# Signals ##########################################################################################



# Enums ############################################################################################

## Weapon classification. Individual class effects TBD.
enum WEAPON_CLASS {LIGHT, MEDIUM, HEAVY, MAGIC, DEFENSE, NONE}

## Weapon damage type. Individual damage type effects TBD.
##
## [br]Determines [member CardAttributes.damage_type] for the [member Weapon.cards]
enum DAMAGE_TYPE {NONE, CUTTING, BLUNT, MAGIC}

## Weapon damage element. Individual damage element effects TBD.
##
## [br]Determines [member CardAttributes.damage_element] for the [member Weapon.cards]
enum DAMAGE_ELEMENT {NONE, FIRE, ICE, LIGHTNING, WATER, LIGHT, DARK}

# Constants ########################################################################################



# @export variables ################################################################################



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
