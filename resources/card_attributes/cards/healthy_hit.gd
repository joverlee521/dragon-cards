class_name HealthyHit
extends CardAttributes
## Class for HealthyHit card to override the base [method CardAttributes.apply_effects_to_opposer]
##
## Do double damage if the card owner is at max health

func apply_effects_to_opposer(card_affectees: CardAffectees, _card_env: CardEnvironment) -> void:
	assert(opposer_target_type == TARGET_TYPE.SINGLE, "HealthyHit should only affect single opposer")
	var original_attack: int = attack

	if card_affectees.owner.character.at_max_health():
		attack = original_attack * 2

	apply_attack(card_affectees.opposer)
	attack = original_attack
