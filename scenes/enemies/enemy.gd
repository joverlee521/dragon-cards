# Base enemy class that does not have a linked scene
# Only inherited by enemy scene scripts
class_name Enemy extends Area2D

signal enemy_selected(enemy) # enemy: Enemy

@export_group("EnemyStats")
@export var health: int = 0:
	set(value):
		health = value
		if is_node_ready():
			$HealthLabel.text = str(health)

@export var cards: Array[CardAttributes] = []

var defense: int = 0:
	set(value):
		defense = value
		if is_node_ready():
			$DefenseLabel.text = str(defense) if defense > 0 else ""
var next_move: CardAttributes:
	set(value):
		next_move = value
		if is_node_ready() and next_move != null:
			$NextMove.text = ""
			if next_move.attack > 0:
				$NextMove.text += "<A>"
			if next_move.defense > 0:
				$NextMove.text += "<D>"

# Click selection variables
var mouse_entered_enemy = false
var selected: bool = false:
	set(value):
		selected = value
		$Sprite/SelectionBorder.visible = selected


func _ready():
	$HealthLabel.text = str(health)
	$Sprite/SelectionBorder.hide()


func pick_next_move() -> void:
	next_move = cards.pick_random()


func play_next_move() -> CardAttributes:
	var played_move = next_move
	defense += played_move.defense
	next_move = null
	return played_move


func remove_health(num: int) -> void:
	if num >= defense:
		num -= defense
		defense = 0
	else:
		defense -= num
		num = 0

	health -= num


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

