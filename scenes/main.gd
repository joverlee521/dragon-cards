class_name Main
extends Node
## The root scene of the game that acts as a switcher for individual game scenese

#region Signals ####################################################################################


#endregion
#region Enums ######################################################################################


#endregion
#region Constants ##################################################################################

const CARD_BATTLE_SCENE = preload("res://scenes/card_battle/card_battle.tscn")

#endregion
#region @export variables ##########################################################################


#endregion
#region Public variables ###########################################################################


#endregion
#region Private variables ##########################################################################


#endregion
#region @onready variables #########################################################################


#endregion
#region Optional _init method ######################################################################


#endregion
#region Optional _enter_tree() method ##############################################################


#endregion
#region Optional _ready method #####################################################################

func _ready() -> void:
	var card_battle = CARD_BATTLE_SCENE.instantiate()
	add_child(card_battle)

#endregion
#region Optional remaining built-in virtual methods ################################################


#endregion
#region Public methods #############################################################################


#endregion
#region Private methods ############################################################################


#endregion
#region Subclasses #################################################################################


#endregion
