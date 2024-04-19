class_name Enemies extends ColorRect


signal all_enemies_defeated

var enemies: Array[PackedScene] = []:
	set(value):
		enemies = value
		if is_node_ready():
			instantiate_enemies()


func _ready():
	# Ignore mouse events here so the individual enemies can be clicked
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	instantiate_enemies()


func instantiate_enemies() -> void:
	for i in len(enemies):
		var enemy = enemies[i].instantiate()
		enemy.position = get_node("Enemy%s" % i).position

		# TODO: Dyanmic selection of enemies
		if i == 0:
			enemy.selected = true

		add_child(enemy)
		enemy.pick_next_move()


func get_all_enemies() -> Array[Node]:
	return get_children().filter(func(node): return node is Enemy)


func get_selected_enemies() -> Array[Node]:
	return get_all_enemies().filter(func(enemy): return enemy.selected)


func attack_enemies(attack: int) -> void:
	var selected_enemies = get_selected_enemies()
	selected_enemies.map(func(enemy): enemy.remove_health(attack))

	if len(get_all_enemies()) == 0:
		all_enemies_defeated.emit()
