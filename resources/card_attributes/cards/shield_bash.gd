class_name ShieldBash
extends CardAttributes
## Class for ShieldBash card to override the base [method CardAttributes.apply_effects]
##
## Add defense to owner if the opposer dies from the attack

func apply_effects(card_affectees: CardAffectees, _card_env: CardEnvironment) -> void:
	apply_attack(card_affectees.opposer)

	if card_affectees.opposer.character.get_health() == 0:
		apply_defense(card_affectees.owner)
