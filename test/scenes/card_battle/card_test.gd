# GdUnit generated TestSuite
class_name CardTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://scenes/card_battle/card.gd"

# Shared variables within TestSuite
var card_attributes: CardAttributes = ResourceLoader.load("res://resources/card_attributes/cards/big_hit.tres")

func test_mouse_left_click() -> void:
	var spied_scene:= spy("res://scenes/card_battle/card.tscn")
	var runner:= scene_runner(spied_scene)
	runner.set_property("card_attributes", card_attributes)
	var card_position: Vector2 = runner.get_property("position")
	runner.set_mouse_pos(card_position)
	await await_idle_frame()
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await await_idle_frame()
	# This shows the _set_selected function is getting called twice!
	# For some reason simulate_mouse_button_pressed creates two events
	verify(spied_scene, 2)._set_selected()
	# For some reason the simulated button press events fire twice,
	# so the card is selected then unselected immediately
	assert_bool(runner.get_property("selected")).is_false()

