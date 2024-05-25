# Base enemy class that does not have a linked scene
# Only inherited by enemy scene scripts
class_name Enemy extends Area2D

signal enemy_clicked(Enemy) # enemy: Enemy

@export_group("EnemyStats")
@export var character: Character

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
	character.init_stats()
	_connect_character_stats_signals()
	_update_health_label()
	_update_defense_label()
	$Sprite/SelectionBorder.hide()


## Chooses a random [CardAttribute] from [member Enemy.character._cards]
func pick_next_card() -> void:
	next_card_attribute = character.cards.pick_random()


## Connects the character's emitted stats signals to the label updates
func _connect_character_stats_signals() -> void:
	character.health_changed.connect(_update_health_label)
	character.defense_changed.connect(_update_defense_label)


func _update_health_label(new_value: int = character._health) -> void:
	$HealthLabel.text = str(new_value)


func _update_defense_label(new_value: int = character._defense) -> void:
	$DefenseLabel.text = str(new_value) if new_value > 0 else ""


# Custom handler for input to work around overlapping Area2D objects both getting input
# See https://github.com/godotengine/godot/issues/29825
# Resolved in https://github.com/godotengine/godot/pull/75688
# which was released in Godot v4.3
func _unhandled_input(event):
	if (event.is_action_pressed("mouse_left_click")
	and mouse_entered_enemy):
		selected = true
		enemy_clicked.emit(self)

		self.get_viewport().set_input_as_handled()


func _on_mouse_entered():
	mouse_entered_enemy = true

func _on_mouse_exited():
	mouse_entered_enemy = false

