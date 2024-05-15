extends CardAttributes


# Override the default effects on card player because the effect depends on
# the outcome of the attack
func apply_effects_to_card_player():
	pass


# Ignores defense and attacks target health directly
func apply_effects_to_card_targets():
	for target in card_targets:
		target.remove_health_directly(attack, damage_type, damage_element)
		play_animation.call(get_attack_animation_string(), target.card_battle_position)
