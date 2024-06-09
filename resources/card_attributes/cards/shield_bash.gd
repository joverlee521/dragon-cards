class_name ShieldBash
extends CardAttributes
## Class for ShieldBash card to override the base [method CardAttributes.apply_effects_to_card_owner]
##
## Add defense to owner only if the opposer dies from the attack

func apply_effects_to_owner(card_affectees: CardAffectees, _card_env: CardEnvironment) -> void:
	assert(owner_target_type == TARGET_TYPE.SINGLE, "ShieldBash should only affect single owner")
	if card_affectees.opposer.character.get_health() == 0:
		apply_defense(card_affectees.owner)
