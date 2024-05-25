class_name EnemyManager
extends PanelContainer
## Container for managing the [Enemy] scenes in the [CardBattle]

## Group for getting [Enemy] nodes that are in battle
const ENEMIES_IN_BATTLE: String = "enemies_in_battle"

## Emitted when all enemies are defeated
signal all_enemies_defeated


func _ready() -> void:
	# Ignore mouse events here so the individual enemies can be clicked
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func instantiate_enemies(enemies: Array[PackedScene]) -> void:
	for i in len(enemies):
		var enemy: Enemy = enemies[i].instantiate()
		enemy.position = get_node("Enemy%s" % i).position
		add_child(enemy)
		enemy.add_to_group(ENEMIES_IN_BATTLE)
		enemy.selected = false
		if i == 0:
			enemy.selected = true
		enemy.enemy_clicked.connect(_on_enemy_clicked)
		enemy.pick_next_card()


func _on_enemy_clicked(clicked_enemy: Enemy) -> void:
	for enemy in get_tree().get_nodes_in_group(ENEMIES_IN_BATTLE):
		if enemy != clicked_enemy:
			enemy.selected = false
