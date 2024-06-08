class_name Enemy
extends Area2D
# Base enemy class that does not have a linked scene
# Only inherited by enemy scene scripts

#region Signals ##########################################################################################

## Emitted when [Enemy] is clicked
signal enemy_clicked(enemy: Enemy)

## Emitted when [Enemy] dies
signal enemy_died(enemy: Enemy)

#endregion
#region Enums ############################################################################################


#endregion
#region Constants ########################################################################################


#endregion
#region @export variables ################################################################################

## The [Character] used for instantiated [Enemy]
## Expected to only provide the [member Character.vocation] for [Enemy]
@export var character: Character

#endregion
#region Public variables #################################################################################


#endregion
#region Private variables ################################################################################

var _next_card_attribute: CardAttributes:
	set = _set_next_card_attribute

var _selected: bool = false:
	set = _set_selected

var _mouse_entered_enemy: bool = false

#endregion
#region @onready variables ###############################################################################


#endregion
#region Optional _init method ############################################################################


#endregion
#region Optional _enter_tree() method ####################################################################


#endregion
#region Optional _ready method ###########################################################################

func _ready() -> void:
	character.resource_local_to_scene = true
	character.init_stats()
	_connect_character_stats_signals()
	_update_health_label()
	_update_defense_label()
	$Sprite/SelectionBorder.hide()

#endregion
#region Optional remaining built-in virtual methods ######################################################

func _unhandled_input(event: InputEvent) -> void:
	# Custom handler for input to work around overlapping Area2D objects both getting input
	# See https://github.com/godotengine/godot/issues/29825
	# Resolved in https://github.com/godotengine/godot/pull/75688
	# which was released in Godot v4.3
	if (event.is_action_pressed("mouse_left_click")
	and _mouse_entered_enemy):
		_selected = true
		enemy_clicked.emit(self)

		self.get_viewport().set_input_as_handled()

#endregion
#region Public methods ###################################################################################

func is_selected() -> bool:
	return _selected


func set_selected(selected: bool) -> void:
	_selected = selected


## Chooses a random [CardAttribute] from [member Enemy.character._cards]
func pick_next_card() -> void:
	_next_card_attribute = character.cards.pick_random()


## Returns a copy of the [member Enemy._next_card_attribute]
func get_next_card() -> CardAttributes:
	return _next_card_attribute.duplicate(true)


func create_card_target() -> CardAttributes.CardTarget:
	return CardAttributes.CardTarget.new(character, global_position)

#endregion
#region Private methods ##############################################################

## Connects the character's emitted stats signals to the label updates
func _connect_character_stats_signals() -> void:
	character.health_changed.connect(_update_health_label)
	character.health_depleted.connect(_on_health_depleted)
	character.defense_changed.connect(_update_defense_label)


func _on_health_depleted() -> void:
	var tween := create_tween()
	tween.tween_property(self, "rotation", 1.5, 1)
	await tween.finished
	enemy_died.emit(self)
	queue_free()


func _update_health_label(new_value: int = character._health) -> void:
	$HealthLabel.text = str(new_value)


func _update_defense_label(new_value: int = character._defense) -> void:
	$DefenseLabel.text = str(new_value) if new_value > 0 else ""


func _set_next_card_attribute(value: CardAttributes) -> void:
	_next_card_attribute = value
	if is_node_ready() and _next_card_attribute != null:
		$NextMove.text = ""
		if _next_card_attribute.attack > 0:
			$NextMove.text += "<A>"
		if _next_card_attribute.defense > 0:
			$NextMove.text += "<D>"


func _set_selected(value: bool) -> void:
	_selected = value
	$Sprite/SelectionBorder.visible = _selected


func _on_mouse_entered() -> void:
	_mouse_entered_enemy = true


func _on_mouse_exited() -> void:
	_mouse_entered_enemy = false

#endregion
#region Subclasses ###################################################################


#endregion
