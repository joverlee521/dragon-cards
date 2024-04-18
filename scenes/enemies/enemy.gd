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


func _ready():
	$HealthLabel.text = str(health)


func remove_health(num: int) -> void:
	health -= num
	if health <= 0:
		self.queue_free()
