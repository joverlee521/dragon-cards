class_name PlayerHand
extends PanelContainer
## Container for [Card]s that are in the player's hand

## Emitted whenever the [member PlayerHand._current_stamina] changes in value
signal stamina_changed(new_value: int)

## The maximum number of cards that can be selected at once
const MAX_SELECTED: int = 1

## The default y position for arranging cards in hand
var _card_y: int = 0
## The x position spacing for cards in hand to evenly space all cards
var _card_spacing: int = 0
## The [Card]s currently in the players hand
var _cards: Array[Card] = []
## Current stamina of the player
var _stamina: int = 0:
	set(val):
		_stamina = val
		stamina_changed.emit(_stamina)


func _ready() -> void:
	_card_y = int(get_rect().size.y / 2)


## Resets the [member PlayerHand._stamina] to the [param stamina]
func reset_stamina(stamina: int) -> void:
	_stamina = stamina


## Adds [param card] to the [member Player._cards] and adds it as a child Node.
## Repositions all of the [member Player._cards] within the container to fit
## the new card
func add_card(card: Card) -> void:
	_cards.append(card)
	add_child(card)
	_position_all_cards()


## Position all [member PlayerHand._cards] within the container
func _position_all_cards() -> void:
	_card_spacing = int(size.x / (_cards.size() + 1))
	for i in len(_cards):
		var card: Card = _cards[i]
		_position_card(card, i+1)


## Position a single [param card] within the container
func _position_card(card: Card, card_order: int) -> void:
	var card_x: int = card_order * _card_spacing

	var current_card_y: int = _card_y
	if card.selected:
		current_card_y -= 50

	card.position = Vector2(card_x, current_card_y)
	card.z_index = card_order

