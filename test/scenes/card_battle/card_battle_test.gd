# GdUnit generated TestSuite
class_name CardBattleTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://scenes/card_battle/card_battle.gd"

# Shared variables within TestSuite
var runner: Object
var player: Character


func before_test() -> void:
	runner = scene_runner("res://scenes/card_battle/card_battle.tscn")
	player = runner.get_property("player")


func test_update_player_health_label() -> void:
	var health_label: Node = runner.find_child("Health")
	var default_health_label: String = "%s / %s" % [player._health, player.vocation.max_health]
	assert_str(health_label.text).is_equal(default_health_label)
	const HEALTH_DAMAGE: int = 10
	var expected_player_health = player._health - HEALTH_DAMAGE
	var expected_health_label: String = "%s / %s" % [expected_player_health, player.vocation.max_health]
	player.take_damage(HEALTH_DAMAGE, true)
	await_signal_on(player, "health_changed", [expected_player_health])
	assert_str(health_label.text).is_equal(expected_health_label)


func test_update_player_defense_label() -> void:
	var defense_label: Node = runner.find_child("Defense")
	var default_defense_label: String = str(player._defense)
	assert_str(defense_label.text).is_equal(default_defense_label)
	const ADD_DEFENSE: int = 10
	var expected_player_defense = player._defense + ADD_DEFENSE
	var expected_defense_label = str(expected_player_defense)
	player.add_defense(ADD_DEFENSE)
	await_signal_on(player, "defense_changed", [expected_player_defense])
	assert_str(defense_label.text).is_equal(expected_defense_label)
