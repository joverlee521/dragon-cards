extends CardAttributes


# Override the default effects on card player because the effect depends on
# the outcome of the attack
func apply_effects_to_card_player():
	pass


# If the card_player is at max health, do double damage
func apply_effects_to_card_targets():
	if card_player.health == card_player.max_health:
		attack = attack * 2
		super()
		attack = attack / 2
	else:
		super()
