class_name Card
extends Area2D
## Base card scene that is instantiated when a card is dealt and/or played

## Emitted when the card is clicked
signal card_clicked

## Minimum label font size
const MIN_LABEL_FONT_SIZE = 10
## Maximum label font size
const MAX_LABEL_FONT_SIZE = 350

## [CardAttributes] to use for the instantiated [Card]
@export var card_attributes: CardAttributes = CardAttributes.new()

## Flag of whether the [Card] is selected
var selected: bool = false
## Flag of whether the [Card] can be clicked
var clickable: bool = true

# Custom handler for input to work around overlapping Area2D objects both getting input
# See https://github.com/godotengine/godot/issues/29825
# Resolved in https://github.com/godotengine/godot/pull/75688
# which was released in Godot v4.3
var _mouse_entered_card: bool = false


# Here for testing purposes
func _init(i_card_attributes: CardAttributes = CardAttributes.new()) -> void:
	card_attributes = i_card_attributes


func _ready() -> void:
	$CardBackground.texture = card_attributes.card_background
	$CardBackground/CardBorder.texture = card_attributes.card_border
	$CardBackground/CardArt.texture = card_attributes.card_art
	$CardBackground/CardDescriptionPlate.texture = card_attributes.card_description_plate
	$CardBackground/CardNamePlate.texture = card_attributes.card_name_plate
	$CardBackground/CardDescriptionPlate/CardDescription.text = card_attributes.card_description
	$CardBackground/CardNamePlate/CardName.text = card_attributes.card_name
	$CardBackground/CardStaminaContainer/StaminaCost.text = str(card_attributes.stamina_cost)

	if card_attributes.attack > 0:
		$CardBackground/CardAttackContainer/CardAttack.text = str(card_attributes.attack)
	else:
		$CardBackground/CardAttackContainer.hide()

	if card_attributes.defense > 0:
		$CardBackground/CardDefenseContainer/CardDefense.text = str(card_attributes.defense)
	else:
		$CardBackground/CardDefenseContainer.hide()

	for child_node in find_children("*", "Label", true):
		if child_node is Label:
			_update_label_font_size(child_node)

## Adjust [Label] font size to fit within the width and height of the [Label]
## Includes a minimum font size of 10 to prevent text from disappearing
func _update_label_font_size(label_node: Label) -> void:
	var font: Font = label_node.get_theme_default_font()
	var font_size: int = MAX_LABEL_FONT_SIZE
	var width: int = label_node.size.x - 5
	var height: int = label_node.size.y - 5

	# TODO: Remove because this slows down the card scene instantiation SIGNIFICANTLY!
	while (
			font_size > MIN_LABEL_FONT_SIZE
			and (font.get_string_size(label_node.text, label_node.horizontal_alignment, -1, font_size).x > width
				or font.get_string_size(label_node.text, label_node.horizontal_alignment, -1, font_size).y > height)
		):
		font_size -= 5

	label_node.add_theme_font_size_override('font_size', font_size)


# Custom handler for input to work around overlapping Area2D objects both getting input
# See https://github.com/godotengine/godot/issues/29825
# Resolved in https://github.com/godotengine/godot/pull/75688
# which was released in Godot v4.3
func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("mouse_left_click")
		and _mouse_entered_card
		and clickable
	):
		_set_selected()
		get_viewport().set_input_as_handled()


func _set_selected() -> void:
	selected = !selected
	card_clicked.emit()


func _on_mouse_entered() -> void:
	_mouse_entered_card = true

func _on_mouse_exited() -> void:
	_mouse_entered_card = false
