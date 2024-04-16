class_name Card extends Area2D

signal card_clicked

@export var attributes: CardAttributes

var mouse_entered_card: bool = false
var is_selected: bool = false
var prevent_selection: bool = false
var is_played: bool = false


func _ready():
	if attributes:
		if attributes.sprite:
			$CardImage.texture = attributes.sprite


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
