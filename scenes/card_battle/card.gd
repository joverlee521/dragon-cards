class_name Card
extends Area2D
## Base card scene that is instantiated when a card is dealt and/or played

# Signals ##########################################################################################

## Emitted when the card is clicked
signal card_clicked(card: Card)

# Enums ############################################################################################



# Constants ########################################################################################

## Minimum label font size
const MIN_LABEL_FONT_SIZE = 10
## Maximum label font size
const MAX_LABEL_FONT_SIZE = 350

# @export variables ################################################################################

## [CardAttributes] to use for the instantiated [Card]
@export var card_attributes: CardAttributes = CardAttributes.new()

# Public variables #################################################################################



# Private variables ################################################################################

var _selected: bool = false
var _clickable: bool = true
# Custom handler for input to work around overlapping Area2D objects both getting input
# See https://github.com/godotengine/godot/issues/29825
# Resolved in https://github.com/godotengine/godot/pull/75688
# which was released in Godot v4.3
var _mouse_entered_card: bool = false

# @onready variables ###############################################################################



# Optional _init method ############################################################################

# Here for testing purposes
func _init(i_card_attributes: CardAttributes = CardAttributes.new()) -> void:
	card_attributes = i_card_attributes

# Optional _enter_tree() method ####################################################################



# Optional _ready method ###########################################################################
func _ready() -> void:
	_set_card_background_textures()
	# TODO: Remove because this slows down the card scene instantiation SIGNIFICANTLY!
	_update_label_font_size()


# Optional remaining built-in virtual methods ######################################################
func _unhandled_input(event: InputEvent) -> void:
	# Custom handler for input to work around overlapping Area2D objects both getting input
	# See https://github.com/godotengine/godot/issues/29825
	# Resolved in https://github.com/godotengine/godot/pull/75688
	# which was released in Godot v4.3
	if (
		event.is_action_pressed("mouse_left_click")
		and _mouse_entered_card
		and _clickable
	):
		_toggle_selected()
		get_viewport().set_input_as_handled()


# Public methods ###################################################################################

func is_selected() -> bool:
	return _selected


func get_stamina_cost() -> int:
	return card_attributes.stamina_cost


func set_clickable(clickable: bool) -> void:
	_clickable = clickable


## Run the scale animation to change the [member Card.scale] to the [param new_scale]
## over a set [param duration] (seconds) with an optional [param delay] (seconds)
## Use `await` to wait for the animation to complete
func run_scale_animation(new_scale: Vector2, duration: float, delay: float = 0.0) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "scale", new_scale, duration).set_delay(delay)
	await tween.finished


# Private methods ##############################################################

func _toggle_selected() -> void:
	_selected = !_selected
	card_clicked.emit(self)


func _set_card_background_textures() -> void:
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


func _update_label_font_size() -> void:
	# Adjust [Label] font size to fit within the width and height of the [Label]
	# Includes a minimum font size of 10 to prevent text from disappearing
	for child_node in find_children("*", "Label", true):
		if child_node is Label:
			var label_node: Label = child_node
			var font: Font = label_node.get_theme_default_font()
			var font_size: int = MAX_LABEL_FONT_SIZE
			var width: float = label_node.size.x - 5
			var height: float = label_node.size.y - 5
			while (
				font_size > MIN_LABEL_FONT_SIZE
				and (font.get_string_size(label_node.text, label_node.horizontal_alignment, -1, font_size).x > width
				or font.get_string_size(label_node.text, label_node.horizontal_alignment, -1, font_size).y > height)
			):
				font_size -= 5

			label_node.add_theme_font_size_override('font_size', font_size)


func _on_mouse_entered() -> void:
	_mouse_entered_card = true


func _on_mouse_exited() -> void:
	_mouse_entered_card = false


# Subclasses ###################################################################
