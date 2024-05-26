class_name EnemyManager
extends PanelContainer
## Container for managing the [Enemy] scenes in the [CardBattle]

# Signals ##########################################################################################

## Emitted when all enemies are defeated
signal all_enemies_defeated

# Enums ############################################################################################



# Constants ########################################################################################

## Group for getting [Enemy] nodes that are in battle
const ENEMIES_IN_BATTLE: String = "enemies_in_battle"

# @export variables ################################################################################



# Public variables #################################################################################



# Private variables ################################################################################



# @onready variables ###############################################################################



# Optional _init method ############################################################################



# Optional _enter_tree() method ####################################################################



# Optional _ready method ###########################################################################
func _ready() -> void:
	# Ignore mouse events here so the individual enemies can be clicked
	mouse_filter = Control.MOUSE_FILTER_IGNORE


# Optional remaining built-in virtual methods ######################################################



# Public methods ###################################################################################

func instantiate_enemies(enemies: Array[PackedScene]) -> void:
	assert(enemies.size() <= 3, "Enemy manager can only hold up to 3 enemies")

	for i in len(enemies):
		var enemy: Enemy = enemies[i].instantiate()
		enemy.position = get_node("Enemy%s" % i).position
		add_child(enemy)
		enemy.add_to_group(ENEMIES_IN_BATTLE)
		enemy.set_selected(false)
		if i == 0:
			enemy.set_selected(true)
		enemy.enemy_clicked.connect(_on_enemy_clicked)
		enemy.enemy_died.connect(_on_enemy_died)
		enemy.pick_next_card()


func get_all_enemies() -> Array[Enemy]:
	return _as_enemy_array(get_tree().get_nodes_in_group(ENEMIES_IN_BATTLE))


func get_all_enemies_as_card_targets() -> Array[CardAttributes.CardTarget]:
	return _as_card_targets_array(get_all_enemies().map(_get_enemy_card_target))


func get_selected_enemy() -> Enemy:
	var selected_enemies: Array[Enemy] = _as_enemy_array(
		get_all_enemies().filter(func (enemy: Enemy) -> bool: return enemy.is_selected())
	)

	assert(selected_enemies.size() == 1, "There should only be one selected enemy")
	return selected_enemies[0]


func get_all_other_enemies(excluded_enemy: Enemy) -> Array[Enemy]:
	return _as_enemy_array(get_all_enemies().filter(
		func (enemy: Enemy) -> bool: return enemy != excluded_enemy
	))


func get_all_other_enemies_as_card_targets(excluded_enemy: Enemy) -> Array[CardAttributes.CardTarget]:
	return _as_card_targets_array(
		get_all_other_enemies(excluded_enemy).map(_get_enemy_card_target)
	)


# Private methods ##################################################################################

func _on_enemy_clicked(clicked_enemy: Enemy) -> void:
	for enemy in get_all_enemies():
		if enemy != clicked_enemy:
			enemy.set_selected(false)


func _on_enemy_died(dead_enemy: Enemy) -> void:
	dead_enemy.remove_from_group(ENEMIES_IN_BATTLE)
	var selected_enemies: Array[Enemy] = _as_enemy_array(
		get_all_enemies().filter(func (enemy: Enemy) -> bool: return enemy.is_selected())
	)
	if selected_enemies.size() == 0:
		get_all_enemies()[0].set_selected(true)


func _get_enemy_card_target(enemy: Enemy) -> CardAttributes.CardTarget:
	return enemy.create_card_target()


func _as_enemy_array(input: Array) -> Array[Enemy]:
	var enemies: Array[Enemy] = []
	enemies.assign(input)
	return enemies


func _as_card_targets_array(input: Array) -> Array[CardAttributes.CardTarget]:
	var targets: Array[CardAttributes.CardTarget] = []
	targets.assign(input)
	return targets

# Subclasses #######################################################################################
