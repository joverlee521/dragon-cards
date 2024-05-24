class_name Deck
extends Node2D
## Base deck for holding [CardAttributes] that can instantiate [Card]s

@export_group("Deck Visual")
@export var deck_name: String = ""
## The image of the deck when [member Deck.cards] is not empty
@export var image: CompressedTexture2D

## The [CardAttributes] currently in the deck
var _cards: Array[CardAttributes] = []


func _ready() -> void:
	if deck_name:
		$DeckName.text = deck_name
	$DeckImage.texture = image
	_update_displays()


## Returns whether the [member Deck._cards] is empty
func is_empty() -> bool:
	return _cards.is_empty()


## Shuffles the [member Deck._cards]
func shuffle() -> void:
	_cards.shuffle()


## Add [param card] to the [member Deck._cards]
func add_card(card: CardAttributes) -> void:
	_cards.append(card)
	_update_displays()


## Remove all [CardAttributes] from [member Deck._cards]
func remove_all_cards() -> Array[CardAttributes]:
	var removed_cards = _cards.duplicate(true)
	_cards = []
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


## Match the displayed card count to the number of [CardAttributes] in [member Deck._cards].
## Only display deck image if there are [member Deck._cards] is not empty
func _update_displays() -> void:
	$CardCount.text = str(len(_cards))
	$DeckImage.visible = not _cards.is_empty()
