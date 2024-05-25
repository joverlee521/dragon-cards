class_name EnemyManager
extends PanelContainer
## Container for managing the [Enemy] scenes in the [CardBattle]

## Emitted when all enemies are defeated
signal all_enemies_defeated
## Emitted when the played enemy card has been handled by the [CardBattle]
signal enemy_card_handled

## Enemies in this card battle
var _enemies: Array[Enemy] = []


func _ready() -> void:
	# Ignore mouse events here so the individual enemies can be clicked
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func add_enemies(enemies: Array[Enemy]) -> void:
	_enemies = enemies
	instantiate_enemies()


func instantiate_enemies() -> void:
	for i in len(_enemies):
		var enemy: Enemy = _enemies[i]
		enemy.position = get_node("Enemy%s" % i).position
		add_child(enemy)
		enemy.selected = false
		if i == 0:
			enemy.selected = true
		enemy.enemy_clicked.connect(_on_enemy_clicked)
		enemy.pick_next_card()


func play_enemy_cards() -> void:
	for enemy in _enemies:
		enemy.play_next_card()
		await enemy_card_handled


func _on_enemy_clicked(clicked_enemy: Enemy) -> void:
	for enemy in _enemies:
		if enemy != clicked_enemy:
			enemy.selected = false
