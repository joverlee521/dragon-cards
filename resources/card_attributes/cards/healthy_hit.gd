class_name HealthyHit
extends CardAttributes
## Class for HealthyHit card to override the base [method CardAttributes.apply_effects]
##
## Do double damage if the card owner is at max health

func apply_effects(card_affectees: CardAffectees, _card_env: CardEnvironment) -> void:
	var original_attack: int = attack

	if card_affectees.owner.character.at_max_health():
		attack = original_attack * 2

	apply_attack(card_affectees.opposer)
	attack = original_attack
