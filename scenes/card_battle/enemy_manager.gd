class_name EnemyManager
extends PanelContainer
## Container for managing the [Enemy] scenes in the [CardBattle]

## Emitted when all enemies are defeated
signal all_enemies_defeated

## Group for all enemiese in battle
const ENEMIES = "enemies_in_battle"

## Enemies in this card battle
var _enemies: Array[PackedScene] = []


func _ready() -> void:
	# Ignore mouse events here so the individual enemies can be clicked
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func add_enemies(enemies: Array[PackedScene]) -> void:
	_enemies = enemies
	instantiate_enemies()


func instantiate_enemies() -> void:
	for i in len(_enemies):
		var enemy: Enemy = _enemies[i].instantiate()
		enemy.position = get_node("Enemy%s" % i).position
		add_child(enemy)
		enemy.add_to_group(ENEMIES)
		enemy.selected = false
		if i == 0:
			enemy.selected = true
		enemy.enemy_clicked.connect(_on_enemy_clicked)
		enemy.pick_next_card()


func _on_enemy_clicked(clicked_enemy: Enemy) -> void:
	for enemy in get_tree().get_nodes_in_group(ENEMIES):
		if enemy != clicked_enemy:
			enemy.selected = false
