class_name Enemies extends ColorRect


signal all_enemies_defeated
signal enemies_acted(enemy_moves) # enemy_moves: Array[CardAttributes]

var enemies = []: #Array[PackedScene]
	set(value):
		remove_all_enemies()
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
		add_child(enemy)
		#TODO: USE GLOBAL POSITION
		enemy.character.set_card_battle_position(enemy.global_position)
		if i == 0:
			enemy.selected = true
		enemy.enemy_selected.connect(_on_enemy_selected)
		enemy.pick_next_move()


func remove_all_enemies() -> void:
	get_all_enemies().map(remove_child)


func get_all_enemies() -> Array[Node]:
	return get_children().filter(func(node): return node is Enemy)


func get_selected_enemies() -> Array[Node]:
	return get_all_enemies().filter(func(enemy): return enemy.selected)


func check_enemies_health() -> void:
	for enemy in get_all_enemies():
		if enemy.character.health <= 0:
			remove_child(enemy)
			enemy.queue_free()

	if len(get_all_enemies()) == 0:
		all_enemies_defeated.emit()
	# If no enemies are selected, always automatically select the first one
	elif len(get_selected_enemies()) == 0:
		get_all_enemies()[0].selected = true


func enemies_move() -> void:
	var enemy_moves = []
	var all_enemies = get_all_enemies()
	all_enemies.map(func(enemy): enemy_moves.append(enemy.get_next_move()))
	emit_signal("enemies_acted", enemy_moves)
	all_enemies.map(func(enemy): enemy.pick_next_move())


func _on_enemy_selected(selected_enemy) -> void:
	get_selected_enemies().map(func(enemy): if enemy != selected_enemy: enemy.selected = false)
