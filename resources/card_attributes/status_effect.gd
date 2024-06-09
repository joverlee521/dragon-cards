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

static func convert_status_effect_to_string(status_effect: STATUS_EFFECT_TYPE) -> String:
	var status_effect_string := ""

	match status_effect:

		STATUS_EFFECT_TYPE.NONE:
			pass

		STATUS_EFFECT_TYPE.POISON:
			status_effect_string = "Poison"

		STATUS_EFFECT_TYPE.FREEZE:
			status_effect_string = "Freeze"

		STATUS_EFFECT_TYPE.KNOCKOUT:
			status_effect_string = "KO"

		STATUS_EFFECT_TYPE.BURN:
			status_effect_string = "Burn"

	return status_effect_string


#endregion
#region Private methods ##################################################################################


#endregion
#region Subclasses #######################################################################################


#endregion
