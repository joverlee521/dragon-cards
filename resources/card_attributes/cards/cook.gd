class_name Cook
extends CardAttributes
## Class for Cook card to override the base [method CardAttributes.apply_effects]
##
## Ignore defense and attack health directly

func apply_effects(card_affectees: CardAffectees, _card_env: CardEnvironment) -> void:
	apply_attack(card_affectees.opposer, true)
