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
		enemy.pick_next_card()


# Private methods ##################################################################################

func _on_enemy_clicked(clicked_enemy: Enemy) -> void:
	for enemy in get_tree().get_nodes_in_group(ENEMIES_IN_BATTLE):
		if enemy != clicked_enemy:
			enemy.set_selected(false)

# Subclasses #######################################################################################
