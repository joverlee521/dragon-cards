extends CardAttributes


# Override the default effects on card player because the effect depends on
# the outcome of the attack
func apply_effects_to_card_player():
	pass


# Add defense to card player if the enemy dies from the attack
func apply_effects_to_card_targets():
	if card_player.health == card_player.max_health:
		card_targets.map(func(target): target.remove_health(attack * 2))
	else:
		super()
