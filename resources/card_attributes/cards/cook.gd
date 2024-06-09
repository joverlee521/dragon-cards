class_name Cook
extends CardAttributes
## Class for Cook card to override the base [method CardAttributes.apply_effects_to_opposer]
##
## Ignore defense and attack health directly

func apply_effects_to_opposer(card_affectees: CardAffectees, _card_env: CardEnvironment) -> void:
	assert(opposer_target_type == TARGET_TYPE.SINGLE, "Cook should only affect single opposer")
	apply_attack(card_affectees.opposer, true)
