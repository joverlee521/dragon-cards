class_name Deck
extends Node2D
## Base deck for holding [CardAttributes] that can instantiate [Card]s

# Signals ##########################################################################################



# Enums ############################################################################################



# Constants ########################################################################################



# @export variables ################################################################################

@export_group("Deck Visual")
@export var deck_name: String = ""
## The image of the deck when [member Deck.cards] is not empty
@export var image: CompressedTexture2D

# Public variables #################################################################################



# Private variables ################################################################################

## The [CardAttributes] currently in the deck
var _cards: Array[CardAttributes] = []

# @onready variables ###############################################################################



# Optional _init method ############################################################################



# Optional _enter_tree() method ####################################################################



# Optional _ready method ###########################################################################
func _ready() -> void:
	$DeckName.text = deck_name
	$DeckImage.texture = image
	_update_displays()


# Optional remaining built-in virtual methods ######################################################



# Public methods ###################################################################################

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


# Private methods ##############################################################

## Match the displayed card count to the number of [CardAttributes] in [member Deck._cards].
## Only display deck image if there are [member Deck._cards] is not empty
func _update_displays() -> void:
	$CardCount.text = str(len(_cards))
	$DeckImage.visible = not _cards.is_empty()

# Subclasses ###################################################################
