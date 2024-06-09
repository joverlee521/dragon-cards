# GdUnit generated TestSuite
class_name CardTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://scenes/card_battle/card.gd"

# Shared variables within TestSuite
var card_attributes: CardAttributes = ResourceLoader.load("res://resources/card_attributes/cards/big_hit.tres")
var spied_scene: Object
var runner: Object


func before_test() -> void:
	spied_scene = spy("res://scenes/card_battle/card.tscn")
	runner = scene_runner(spied_scene)
	runner.set_property("card_attributes", card_attributes)


func test_mouse_left_click_drag() -> void:
	const FINAL_POSITION = Vector2(500, 500)
	const FINAL_POSITION_BUFFER = Vector2(10, 10)
	var card_position: Vector2 = runner.get_property("position")
	runner.set_mouse_pos(card_position)
	await await_idle_frame()
	# Click on card
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await await_idle_frame()
	# Drag card
	assert_bool(runner.get_property("_dragging")).is_true()
	runner.simulate_mouse_move(FINAL_POSITION)
	await await_idle_frame()
	var dragging_area:Node = runner.find_child("CardDraggingArea")
	assert_vector(dragging_area.global_position).is_equal_approx(FINAL_POSITION, FINAL_POSITION_BUFFER)
	# Release card
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await await_idle_frame()
	assert_bool(runner.get_property("_dragging")).is_false()

