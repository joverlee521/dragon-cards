class_name Card
extends Area2D
## Base card scene that is instantiated when a card is dealt and/or played

#region Signals ##########################################################################################

## Emitted when the card is released after dragging
signal card_released(card: Card)

#endregion
#region Enums ############################################################################################


#endregion
#region Constants ########################################################################################

## Minimum label font size
const MIN_LABEL_FONT_SIZE = 10
## Maximum label font size
const MAX_LABEL_FONT_SIZE = 350

#endregion
#region @export variables ################################################################################

## [CardAttributes] to use for the instantiated [Card]
@export var card_attributes: CardAttributes = CardAttributes.new()

#endregion
#region Public variables #################################################################################


#endregion
#region Private variables ################################################################################

var _clickable: bool = true
# Custom handler for input to work around overlapping Area2D objects both getting input
# See https://github.com/godotengine/godot/issues/29825
# Resolved in https://github.com/godotengine/godot/pull/75688
# which was released in Godot v4.3
var _mouse_entered_card: bool = false
var _dragging: bool = false
var _pre_dragging_position: Vector2

#endregion
#region @onready variables ###############################################################################


#endregion
#region Optional _init method ############################################################################

# Here for testing purposes
func _init(i_card_attributes: CardAttributes = CardAttributes.new()) -> void:
	card_attributes = i_card_attributes

#endregion
#region Optional _enter_tree() method ####################################################################


#endregion
#region Optional _ready method ###########################################################################

func _ready() -> void:
	$CardAnimationLayer/CardAnimation.hide()
	card_attributes.triggered_animation.connect(_on_triggered_animation)
	_set_card_background_textures()
	# TODO: Remove because this slows down the card scene instantiation SIGNIFICANTLY!
	_update_label_font_size()

#endregion
#region Optional remaining built-in virtual methods ######################################################

func _process(_delta:float) -> void:
	if _dragging:
		var mouse_position := get_viewport().get_mouse_position()
		self.global_position = Vector2(mouse_position.x, mouse_position.y)


func _unhandled_input(event: InputEvent) -> void:
	# Custom handler for input to work around overlapping Area2D objects both getting input
	# See https://github.com/godotengine/godot/issues/29825
	# Resolved in https://github.com/godotengine/godot/pull/75688
	# which was released in Godot v4.3
	if _mouse_entered_card and _clickable:
		if event.is_action_pressed("mouse_left_click"):
			_pre_dragging_position = self.global_position
			_dragging = true
		elif event.is_action_released("mouse_left_click"):
			_dragging = false
			card_released.emit(self)

		get_viewport().set_input_as_handled()


#endregion
#region Public methods ###################################################################################


func get_stamina_cost() -> int:
	return card_attributes.stamina_cost


func set_clickable(clickable: bool) -> void:
	_clickable = clickable


func return_to_pre_dragging_position() -> void:
	self.global_position = _pre_dragging_position


func is_group_opposer_target_type() -> bool:
	return card_attributes.opposer_target_type == CardAttributes.TARGET_TYPE.GROUP


## Run the scale animation to change the [member Card.scale] to the [param new_scale]
## over a set [param duration] (seconds) with an optional [param delay] (seconds)
## Use `await` to wait for the animation to complete
func run_scale_animation(new_scale: Vector2, duration: float, delay: float = 0.0) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "scale", new_scale, duration).set_delay(delay)
	await tween.finished


func play(card_affectees: CardAttributes.CardAffectees,
		  card_env: CardAttributes.CardEnvironment) -> void:
	card_attributes.apply_effects(card_affectees, card_env)

#endregion
#region Private methods ##############################################################

func _on_triggered_animation(animation_name: String, animation_position: Vector2) -> void:
	var card_animation: AnimatedSprite2D = $CardAnimationLayer/CardAnimation.duplicate()
	$CardAnimationLayer.add_child(card_animation)
	# Check requested animation exists
	assert(card_animation.sprite_frames.has_animation(animation_name),
		"Cannot play animation <%s> that does not exist!" % animation_name)

	card_animation.position = animation_position
	card_animation.show()
	card_animation.play(animation_name)
	await card_animation.animation_finished
	$CardAnimationLayer.remove_child(card_animation)
	card_animation.queue_free()


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

#endregion
#region Subclasses ###################################################################


#endregion
