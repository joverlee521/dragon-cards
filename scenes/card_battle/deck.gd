class_name Deck
extends Node2D
## Base deck for holding [CardAttributes] that can instantiate [Card]s

#region Signals ##########################################################################################


#endregion
#region Enums ############################################################################################


#endregion
#region Constants ########################################################################################


#endregion
#region @export variables ################################################################################

@export_group("Deck Visual")
@export var deck_name: String = ""
## The image of the deck when [member Deck.cards] is not empty
@export var image: CompressedTexture2D

#endregion
#region Public variables #################################################################################


#endregion
#region Private variables ################################################################################

## The [CardAttributes] currently in the deck
var _cards: Array[CardAttributes] = []

#endregion
#region @onready variables ###############################################################################


#endregion
#region Optional _init method ############################################################################


#endregion
#region Optional _enter_tree() method ####################################################################


#endregion
#region Optional _ready method ###########################################################################

func _ready() -> void:
	$DeckName.text = deck_name
	$DeckImage.texture = image
	_update_displays()

#endregion
#region Optional remaining built-in virtual methods ######################################################


#endregion
#region Public methods ###################################################################################

func get_cards() -> Array[CardAttributes]:
	return _cards


func is_empty() -> bool:
	return _cards.is_empty()


func shuffle() -> void:
	_cards.shuffle()


func add_card(card: CardAttributes) -> void:
	_cards.append(card)
	_update_displays()


func remove_all_cards() -> Array[CardAttributes]:
	var removed_cards: Array[CardAttributes] = _cards.duplicate(true)
	_cards = []
	_update_displays()
	return removed_cards


## Returns [CardAttributes] from [member Deck._cards] at the [param index]
func remove_card(index: int = 0) -> CardAttributes:
	var removed_card: CardAttributes = _cards.pop_at(index)
	_update_displays()
	return removed_card


## Replace the [member Deck._cards] with the [param new_cards]
func replace_cards(new_cards: Array[CardAttributes]) -> void:
	_cards.clear()
	_cards.assign(new_cards)
	_update_displays()

#endregion
#region Private methods ##############################################################

## Match the displayed card count to the number of [CardAttributes] in [member Deck._cards].
## Only display deck image if there are [member Deck._cards] is not empty
func _update_displays() -> void:
	$CardCount.text = str(len(_cards))
	$DeckImage.visible = not _cards.is_empty()

#endregion
#region Subclasses ###################################################################


#endregion
