class_name Deck
extends Node2D
## Base deck for holding [CardAttributes] that can instantiate [Card]s

## Emitted when cards are removed from [member Deck.cards]
signal removed_cards(cards: Array[CardAttributes])

@export_group("Deck Visual")
## The image of the deck when [member Deck.cards] is not empty
@export var image: CompressedTexture2D

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
	remove_first_cards(_cards.size())


## Remove the first [param num] [CardAttributes] from [member Deck._cards]
func remove_first_cards(num: int) -> void:
	if _cards.size() == 0:
		return

	if num > _cards.size():
		num = _cards.size()

	var cards_to_remove: Array[CardAttributes] = _cards.slice(0, num, 1, true)
	_cards.assign(_cards.slice(num))
	_update_displays()
	removed_cards.emit(cards_to_remove)


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
