class_name Main
extends Node
## The root scene of the game that acts as a switcher for individual game scenese

#region Signals ####################################################################################


#endregion
#region Enums ######################################################################################


#endregion
#region Constants ##################################################################################

const CARD_BATTLE_SCENE = preload("res://scenes/card_battle/card_battle.tscn")
const PLAY_TEST_CARD_BATTLE_SCENE = preload("res://scenes/card_battle/play_test.tscn")

#endregion
#region @export variables ##########################################################################


#endregion
#region Public variables ###########################################################################


#endregion
#region Private variables ##########################################################################

var _start_screen: Node
var _card_battle: Node
var _play_test_card_battle: Node

#endregion
#region @onready variables #########################################################################


#endregion
#region Optional _init method ######################################################################


#endregion
#region Optional _enter_tree() method ##############################################################


#endregion
#region Optional _ready method #####################################################################

func _ready() -> void:
	_start_screen = $StartScreen

#endregion
#region Optional remaining built-in virtual methods ################################################


#endregion
#region Public methods #############################################################################


#endregion
#region Private methods ############################################################################

func _on_start_game_pressed() -> void:
	print("START GAME")
	remove_child(_start_screen)
	_card_battle = CARD_BATTLE_SCENE.instantiate()
	_card_battle.exit_card_battle.connect(_on_exit_card_battle)
	add_child(_card_battle)


func _on_exit_card_battle(_exit_status: CardBattle.EXIT_STATUS, _player: Character) -> void:
	remove_child(_card_battle)
	_card_battle.queue_free()
	get_tree().paused = false
	# TODO: use _exit_status to determine which scene to switch to here
	# TODO: pass _player to the next scene
	add_child(_start_screen)


func _on_start_card_battle_play_test_pressed() -> void:
	print("START CARD BATTLE PLAY TEST")
	remove_child(_start_screen)
	_play_test_card_battle = PLAY_TEST_CARD_BATTLE_SCENE.instantiate()
	add_child(_play_test_card_battle)



#endregion
#region Subclasses #################################################################################


#endregion
