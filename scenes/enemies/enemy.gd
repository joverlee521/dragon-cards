# Base enemy class that does not have a linked scene
# Only inherited by enemy scene scripts
class_name Enemy extends Area2D


@export_group("EnemyStats")
@export var health: int = 0:
	set(value):
		health = value
		if is_node_ready():
			$HealthLabel.text = str(health)

@export var cards: Array[CardAttributes] = []

var selected: bool = false
var next_move: CardAttributes:
	set(value):
		next_move = value
		if is_node_ready() and next_move != null:
			$NextMove.text = ""
			if next_move.attack > 0:
				$NextMove.text += "<A>"
			if next_move.defense > 0:
				$NextMove.text += "<D>"


func _ready():
	$HealthLabel.text = str(health)


func pick_next_move() -> void:
	next_move = cards.pick_random()


func play_next_move() -> CardAttributes:
	var played_move = next_move
	next_move = null
	return played_move


func remove_health(num: int) -> void:
	health -= num
	if health <= 0:
		self.queue_free()
