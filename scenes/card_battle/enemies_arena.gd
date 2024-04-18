class_name Enemies extends ColorRect


signal all_enemies_defeated

@export var enemies: Array[PackedScene] = []


func _ready():
	# Ignore mouse events here so the individual enemies can be clicked
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	# TODO: dynamically set enemies
	#var goblin = preload("res://scenes/enemies/GoblinEnemy.tscn").instantiate()
	#goblin.selected = true
	#goblin.position = $Enemy1.position
	#add_child(goblin)
	for enemy in enemies:
		var goblin = enemy.instantiate()
		add_child(goblin)


func get_all_enemies() -> Array[Node]:
	return get_children().filter(func(node): return node is Enemy)


func get_selected_enemies() -> Array[Node]:
	return get_all_enemies().filter(func(enemy): return enemy.selected)


func attack_enemies(attack: int) -> void:
	var selected_enemies = get_selected_enemies()
	selected_enemies.map(func(enemy): enemy.remove_health(attack))

	if len(get_all_enemies()) == 0:
		all_enemies_defeated.emit()
