class_name StatusEffect
extends Resource
## Base resource for status effects applied by cards

#region Signals ##########################################################################################


#endregion
#region Enums ############################################################################################

enum STATUS_EFFECT_TYPE {
	NONE,
	POISON,
	FREEZE,
	KNOCKOUT,
	BURN,
}

#endregion
#region Constants ########################################################################################


#endregion
#region @export variables ################################################################################

## Type of status effect to apply
@export var status_effect_type: STATUS_EFFECT_TYPE = STATUS_EFFECT_TYPE.NONE
## Stack number of status effect to apply
@export var applied_number: int = 0

#endregion
#region Public variables #################################################################################


#endregion
#region Private variables ################################################################################


#endregion
#region @onready variables ###############################################################################


#endregion
#region Optional _init method ############################################################################

# Here for testing purposes
func _init(_status_effect_type: STATUS_EFFECT_TYPE = STATUS_EFFECT_TYPE.NONE,
		   _applied_number: int = 0) -> void:
	status_effect_type = _status_effect_type
	applied_number = _applied_number

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
