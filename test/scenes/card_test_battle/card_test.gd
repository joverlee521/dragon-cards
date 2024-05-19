# GdUnit generated TestSuite
class_name CardTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://scenes/card_battle/card.gd"


func test__update_label_font_size() -> void:
	var card: Card = load(__source).new()
	var label := Label.new()
	card.add_child(label)
	label.text = "SUPER LOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOONG TEXT"
	card._update_label_font_size(label)
	assert_int(label.get_theme_font_size('font_size')).is_equal(10)
