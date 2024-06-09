class_name ChaosSlash
extends CardAttributes
## Class for ChaosSlash card to override the base [method CardAttributes.apply_effects_to_opposer]
##
## If there are no cards in the discard deck, then attack as usual
## If there are cards in the discard deck, then add 1 for each attack per card
## Permanently remove all discarded cards for the current card battle

func apply_effects_to_opposer(card_affectees: CardAffectees, card_env: CardEnvironment) -> void:
	assert(opposer_target_type == TARGET_TYPE.SINGLE, "Cook should only affect single opposer")
	var num_cards_in_discard_deck := card_env.discard_deck.get_cards().size()

	if num_cards_in_discard_deck == 0:
		apply_attack(card_affectees.opposer)
	else:
		for i: int in num_cards_in_discard_deck:
			apply_attack(card_affectees.opposer)
			attack += 1

	attack = 1
	card_env.discard_deck.remove_all_cards()
