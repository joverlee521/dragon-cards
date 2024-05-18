class_name StatusEffect
extends Resource
## Base resource for status effects applied by cards

enum STATUS_EFFECT_TYPE {
	NONE,
	POISON,
	FREEZE,
	KNOCKOUT,
	BURN,
}

## Type of status effect to apply
@export var status_effect_type: STATUS_EFFECT_TYPE = STATUS_EFFECT_TYPE.NONE
## Stack number of status effect to apply
@export var applied_number: int = 0
