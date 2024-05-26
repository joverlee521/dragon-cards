class_name Item
extends Resource
## Base resource for storing item stats

#region Signals ##########################################################################################


#endregion
#region Enums ############################################################################################


#endregion
#region Constants ########################################################################################


#endregion
#region @export variables ################################################################################

@export_group("Item Visual")
## Item's displayed name
@export var name: String = ""
## Item's displayed sprite
@export var sprite: AtlasTexture

@export_group("Cards")
## [CardAttributes] associated with item
@export var card_attributes: Array[CardAttributes] = []

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


#endregion
#region Private methods ##################################################################################


#endregion
#region Subclasses #######################################################################################


#endregion
