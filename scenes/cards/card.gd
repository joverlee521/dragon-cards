class_name Card extends Area2D

signal card_clicked

@export var attributes: CardAttributes

var mouse_entered_card: bool = false
var is_selected: bool = false
var prevent_selection: bool = false
var is_played: bool = false


func _ready():
	if attributes:
		if attributes.card_background:
			$CardBackground.texture = attributes.card_background
			print(attributes.card_background)
		if attributes.card_border:
			$CardBackground/CardBorder.texture = attributes.card_border
		if attributes.card_art:
			$CardBackground/CardArt.texture = attributes.card_art
		if attributes.card_description_plate:
			$CardBackground/CardDescriptionPlate.texture = attributes.card_description_plate
		if attributes.card_name_plate:
			$CardBackground/CardNamePlate.texture = attributes.card_name_plate
		if attributes.card_description:
			$CardBackground/CardDescriptionPlate/CardDescription.text = attributes.card_description
		if attributes.card_name:
			$CardBackground/CardNamePlate/CardName.text = attributes.card_name


# Custom handler for input to work around overlapping Area2D objects both getting input
# See https://github.com/godotengine/godot/issues/29825
# Resolved in https://github.com/godotengine/godot/pull/75688
# which was released in Godot v4.3
func _unhandled_input(event):
	if (event.is_action_pressed("mouse_left_click")
	and mouse_entered_card):
		if !is_played and (!prevent_selection or is_selected):
			is_selected = !is_selected
			card_clicked.emit()

		self.get_viewport().set_input_as_handled()


func _on_mouse_entered():
	mouse_entered_card = true

func _on_mouse_exited():
	mouse_entered_card = false

func _on_cards_selected(max_cards_selected):
	prevent_selection = max_cards_selected
