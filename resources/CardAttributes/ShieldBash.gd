extends CardAttributes


# Override the default effects on card player because the effect depends on
# the outcome of the attack
func apply_effects_to_card_player():
	pass


# Add defense to card player if the enemy dies from the attack
func apply_effects_to_card_targets():
	super()

	if card_targets.any(func(target): return target.health <= 0):
		card_player.add_defense(defense)
