class_name CardAttributes
extends Resource
## Base resource for storing and calculating card effects

# Signals ##########################################################################################



# Enums ############################################################################################

## Options for the [member CardAttributes.target_type]
enum TARGET_TYPE {
	## Card only attacks a single target
	SINGLE,
	## Card attacks groups of targets
	GROUP,
}

# Constants ########################################################################################



# @export variables ################################################################################

@export_group("Card Visual")
## Displayed card name
@export var card_name : String = ""
## Displayed card background
@export var card_background: AtlasTexture
## Displayed card border
@export var card_border: AtlasTexture
## Displayed card art
@export var card_art : AtlasTexture
## Displayed background for the card description
@export var card_description_plate : AtlasTexture
## Displayed background for the card name
@export var card_name_plate : AtlasTexture
## Displayed card description
@export var card_description : String = ""

@export_group("Card Stats")
## Card's [enum CardAttributes.TARGET_TYPE]
@export var target_type: TARGET_TYPE = TARGET_TYPE.SINGLE
## Card's base attack damage
@export var attack: int = 0
## Card's base defense added
@export var defense: int = 0
## Card's base stamina cost to be played
@export var stamina_cost: int = 0
## Card's base damage type
@export var damage_type: Weapon.DAMAGE_TYPE = Weapon.DAMAGE_TYPE.NONE
## Card's base damage element
@export var damage_element: Weapon.DAMAGE_ELEMENT = Weapon.DAMAGE_ELEMENT.NONE
## Card's status effects applied to the card player
@export var status_effects_on_card_player: Array[StatusEffect]
## Card's status effects applied to the card target
@export var status_effects_on_card_target: Array[StatusEffect]

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
