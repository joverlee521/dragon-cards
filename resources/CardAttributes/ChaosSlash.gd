extends CardAttributes


# Override the default effects on card player because the effect depends on
# the outcome of the attack
func apply_effects_to_card_player():
	pass


# Ignores defense and attacks target health directly
func apply_effects_to_card_targets():
	var num_cards_in_discard_deck = discard_deck.size()
	
	for i in num_cards_in_discard_deck:
		await super()
		attack += 1
		
	attack = 1
