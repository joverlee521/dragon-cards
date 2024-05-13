# Base enemy class that does not have a linked scene
# Only inherited by enemy scene scripts
class_name Enemy extends Area2D

signal enemy_selected(enemy) # enemy: Enemy

@export_group("EnemyStats")
@export var character: Character
@export var cards: Array = []

var next_card_attribute: CardAttributes:
	set(value):
		next_card_attribute = value
		if is_node_ready() and next_card_attribute != null:
			$NextMove.text = ""
			if next_card_attribute.attack > 0:
				$NextMove.text += "<A>"
			if next_card_attribute.defense > 0:
				$NextMove.text += "<D>"

# Click selection variables
var mouse_entered_enemy = false
var selected: bool = false:
	set(value):
		selected = value
		$Sprite/SelectionBorder.visible = selected


func _ready():
	character.resource_local_to_scene = true
	character.init_health()
	set_stat_labels()
	$Sprite/SelectionBorder.hide()


func set_stat_labels() -> void:
	$HealthLabel.text = str(character.health)
	if character.defense > 0:
		$DefenseLabel.text = str(character.defense)
	else:
		$DefenseLabel.text = ''


func pick_next_card_attribute() -> void:
	next_card_attribute = cards.pick_random()


func get_next_card_attribute() -> CardAttributes:
	var played_card_attribute = next_card_attribute
	played_card_attribute.set_card_player(character)
	next_card_attribute = null
	return played_card_attribute


# Custom handler for input to work around overlapping Area2D objects both getting input
# See https://github.com/godotengine/godot/issues/29825
# Resolved in https://github.com/godotengine/godot/pull/75688
# which was released in Godot v4.3
func _unhandled_input(event):
	if (event.is_action_pressed("mouse_left_click")
	and mouse_entered_enemy):
		selected = true
		emit_signal("enemy_selected", self)

		self.get_viewport().set_input_as_handled()


func _on_mouse_entered():
	mouse_entered_enemy = true

func _on_mouse_exited():
	mouse_entered_enemy = false

