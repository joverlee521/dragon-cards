class_name Card
extends Area2D
## Base card scene that is instantiated when a card is dealt and/or played

## Emitted when the card is clicked
signal card_clicked

## [CardAttributes] to use for the instantiated [Card]
@export var card_attributes: CardAttributes

## Flag of whether the [Card] is selected
var selected: bool = false
## Flag of whether the [Card] can be clicked
var clickable: bool = true

# Custom handler for input to work around overlapping Area2D objects both getting input
# See https://github.com/godotengine/godot/issues/29825
# Resolved in https://github.com/godotengine/godot/pull/75688
# which was released in Godot v4.3
var _mouse_entered_card: bool = false


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
	const MIN_FONT_SIZE = 10
	var font: Font = label_node.get_theme_default_font()
	var font_size: int = 350
	var width: int = label_node.size.x - 5
	var height: int = label_node.size.y - 5

	while (
			font_size >= MIN_FONT_SIZE
			and (font.get_string_size(label_node.text, label_node.horizontal_alignment, -1, font_size).x > width
				or font.get_string_size(label_node.text, label_node.horizontal_alignment, -1, font_size).y > height)
		):
		font_size -= 1

	label_node.add_theme_font_size_override('font_size', font_size)


# Custom handler for input to work around overlapping Area2D objects both getting input
# See https://github.com/godotengine/godot/issues/29825
# Resolved in https://github.com/godotengine/godot/pull/75688
# which was released in Godot v4.3
func _unhandled_input(event) -> void:
	if (
		event.is_action_pressed("mouse_left_click")
		and _mouse_entered_card
		and clickable
	):
		selected = !selected
		card_clicked.emit()
		get_viewport().set_input_as_handled()


func _on_mouse_entered() -> void:
	_mouse_entered_card = true

func _on_mouse_exited() -> void:
	_mouse_entered_card = false
