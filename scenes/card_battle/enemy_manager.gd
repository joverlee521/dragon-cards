class_name EnemyManager
extends Area2D
## Container for managing the [Enemy] scenes in the [CardBattle]

#region Signals ##########################################################################################

## Emitted when all enemies are defeated
signal all_enemies_defeated

#endregion
#region Enums ############################################################################################


#endregion
#region Constants ########################################################################################

## Group for getting [Enemy] nodes that are in battle
const ENEMIES_IN_BATTLE: String = "enemies_in_battle"

#endregion
#region @export variables ################################################################################


#endregion
#region Public variables #################################################################################


#endregion
#region Private variables ################################################################################


#endregion
#region @onready variables ###############################################################################


#endregion
#region Optional _init method ############################################################################


#endregion
#region Optional _enter_tree() method ####################################################################


#endregion
#region Optional _ready method ###########################################################################


#endregion
#region Optional remaining built-in virtual methods ######################################################


#endregion
#region Public methods ###################################################################################

func instantiate_enemies(enemies: Array[PackedScene]) -> void:
	assert(enemies.size() <= 3, "Enemy manager can only hold up to 3 enemies")

	for i in len(enemies):
		var enemy: Enemy = enemies[i].instantiate()
		enemy.position = get_node("Enemy%s" % i).position
		add_child(enemy)
		enemy.add_to_group(ENEMIES_IN_BATTLE)
		enemy.set_selected(false)
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

#endregion
#region Private methods ##################################################################################


func _on_enemy_died(dead_enemy: Enemy) -> void:
	dead_enemy.remove_from_group(ENEMIES_IN_BATTLE)
	if get_all_enemies().size() == 0:
		all_enemies_defeated.emit()
		return

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


func _on_area_entered(area: Area2D) -> void:
	if area.name == Card.CARD_DRAGGING_AREA:
		if area.get_parent().is_group_opposer_target_type():
			get_tree().call_group(ENEMIES_IN_BATTLE, "set_selected", true)


func _on_area_exited(area: Area2D) -> void:
	if area.name == Card.CARD_DRAGGING_AREA:
		get_tree().call_group(ENEMIES_IN_BATTLE, "set_selected", false)

#endregion
#region Subclasses #######################################################################################


#endregion
