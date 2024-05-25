class_name PlayerHand
extends PanelContainer
## Container for [Card]s that are in the player's hand

## Emitted whenever the [member PlayerHand._current_stamina] changes in value
signal stamina_changed(new_value: int)
## Emitted whenever [Card] selection changes
signal card_selection_changed(num_selected: int)

## The maximum number of cards that can be selected at once
const MAX_SELECTED: int = 1
## Group name for cards that are not selected
const PLAYER_NOT_SELECTED_CARDS = "player_not_selected_cards"
## Group name for cards that are selected
const PLAYER_SELECTED_CARDS = "player_selected_cards"

## The default y position for arranging cards in hand
var _card_y: int = 0
## The x position spacing for cards in hand to evenly space all cards
var _card_spacing: int = 0
## The [Card]s currently in the players hand used for ordering and positioning
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
	# Signal connection to prevent selecting more cards than the MAX_SELECTED
	card.card_clicked.connect(_on_card_clicked)
	_cards.append(card)
	add_child(card)
	card.add_to_group(PLAYER_NOT_SELECTED_CARDS)
	_position_all_cards()


func play_selected_cards() -> Array[Card]:
	get_tree().call_group(PLAYER_NOT_SELECTED_CARDS, "set_clickable", false)
	var selected_cards: Array[Card] = []
	selected_cards.assign(get_tree().get_nodes_in_group(PLAYER_SELECTED_CARDS))
	for card in selected_cards:
		_cards.erase(card)
		card.remove_from_group(PLAYER_SELECTED_CARDS)
		remove_child(card)
	_position_all_cards()
	return selected_cards


func discard_all_cards() -> Array[Card]:
	for card in _cards:
		card.remove_from_group(PLAYER_NOT_SELECTED_CARDS)
		card.remove_from_group(PLAYER_SELECTED_CARDS)
		remove_child(card)
	var discarded_cards = _cards.duplicate(true)
	_cards = []
	return discarded_cards


func set_cards_clickable(clickable: bool) -> void:
	get_tree().call_group(PLAYER_NOT_SELECTED_CARDS, "set_clickable", clickable)


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


## Filters [member PlayerHand._cards] for [Card]s that are selected
func _get_selected_cards() -> Array[Card]:
	return _cards.filter(func(card): return card.is_selected)


## Checks for selected cards and prevents selecting additional
## cards if the number of selected cards is equal to [member PlayerHand.MAX_SELECTED]
func _on_card_clicked(clicked_card: Card) -> void:
	if clicked_card.selected:
		clicked_card.add_to_group(PLAYER_SELECTED_CARDS)
		clicked_card.remove_from_group(PLAYER_NOT_SELECTED_CARDS)
	else:
		clicked_card.add_to_group(PLAYER_NOT_SELECTED_CARDS)
		clicked_card.remove_from_group(PLAYER_SELECTED_CARDS)

	var num_selected_cards: int = get_tree().get_nodes_in_group(PLAYER_SELECTED_CARDS).size()
	get_tree().call_group(
		PLAYER_NOT_SELECTED_CARDS,
		"set_clickable",
		true if num_selected_cards < MAX_SELECTED else false
	)
	_position_all_cards()
	card_selection_changed.emit(num_selected_cards)
