class_name Deck
extends Node2D
## Base deck for holding [CardAttributes] that can instantiate [Card]s

## Emitted when cards are removed from [member Deck.cards]
signal removed_cards(cards: Array[CardAttributes])

@export_group("Deck Visual")
## The image of the deck when [member Deck.cards] is not empty
@export var image: CompressedTexture2D
## The [Card] scene to use for instantiating cards
@export var card_scene: PackedScene

## The [CardAttributes] currently in the deck
var _cards: Array[CardAttributes] = []


func _ready() -> void:
	$DeckImage.texture = image
	_update_displays()


func shuffle() -> void:
	_cards.shuffle()


## Add [param card] to the [member Deck._cards]
func add_card(card: CardAttributes) -> void:
	_cards.append(card)
	_update_displays()


## Remove all [CardAttributes] from [member Deck._cards]
func remove_all_cards() -> void:
	var cards_to_remove = _cards.duplicate(true)
	_cards.clear()
	_update_displays()
	removed_cards.emit(cards_to_remove)


## Remove the first [param num] [CardAttributes] from [member Deck._cards]
func remove_first_cards(num: int) -> void:
	var cards_to_remove: Array[CardAttributes] = _cards.slice(0, num, 1, true)
	for i in num:
		_cards.remove_at(i)
	removed_cards.emit(cards_to_remove)


## Remove and returns the [CardAttributes] from [member Deck.cards]
## at index [param index]
func _remove_card(index: int) -> CardAttributes:
	var removed_card: CardAttributes = _cards.pop_at(index)
	_update_displays()
	return removed_card


## Match the displayed card count to the number of [CardAttributes] in [member Deck.cards].
## Only display deck image if there are [member Deck.cards] is not empty
func _update_displays() -> void:
	$CardCount.text = str(len(_cards))
	$DeckImage.visible = not _cards.is_empty()
