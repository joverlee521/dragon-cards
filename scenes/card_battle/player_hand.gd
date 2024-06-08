class_name PlayerHand
extends PanelContainer
## Container for [Card]s that are in the player's hand

#region Signals ##########################################################################################

## Emitted whenever the [member PlayerHand._current_stamina] changes in value
signal stamina_changed(new_value: int)
## Emitted whenever [Card] selection changes with boolean of whether selected card is playable
signal card_selection_changed(selected_card_playable: bool)

#endregion
#region Enums ############################################################################################


#endregion
#region Constants ########################################################################################

## Group for getting [Card] nodes that are in [PlayerHand]
const CARDS_IN_PLAYER_HAND: String = "cards_in_player_hand"

#endregion
#region @export variables ################################################################################


#endregion
#region Public variables #################################################################################


#endregion
#region Private variables ################################################################################

## The default y position for arranging cards in hand
var _card_y: int = 0
## The x position spacing for cards in hand to evenly space all cards
var _card_spacing: int = 0
## The [Card]s currently in the players hand used for ordering and positioning
var _cards: Array[Card] = []
## Current stamina of the player
var _stamina: int = 0:
	set = _set_stamina

#endregion
#region @onready variables ###############################################################################


#endregion
#region Optional _init method ############################################################################


#endregion
#region Optional _enter_tree() method ####################################################################


#endregion
#region Optional _ready method ###########################################################################

func _ready() -> void:
	_card_y = int(get_rect().size.y / 2)

#endregion
#region Optional remaining built-in virtual methods ######################################################


#endregion
#region Public methods ###################################################################################

func reset_stamina(stamina: int) -> void:
	_stamina = stamina


func add_card(card: Card) -> void:
	# Signal connection to prevent selecting more cards than the MAX_SELECTED
	card.card_clicked.connect(_on_card_clicked)
	_cards.append(card)
	add_child(card)
	card.add_to_group(CARDS_IN_PLAYER_HAND)
	_position_all_cards()


func play_selected_card() -> Card:
	set_cards_clickable(false)
	var selected_cards: Array[Card] = _get_selected_card()
	assert(selected_cards.size() == 1, "Unable to play because no cards are selected")

	var selected_card: Card = selected_cards[0]
	var stamina_cost: int = selected_card.get_stamina_cost()
	assert(stamina_cost <= _stamina, "Unable to play selected card because the stamina cost is greater than the player's remaining stamina")

	_stamina -= stamina_cost
	_remove_card(selected_card)
	_position_all_cards()
	card_selection_changed.emit(false)
	return selected_card


func discard_all_cards() -> Array[Card]:
	var discarded_cards: Array[Card] = _cards.duplicate(true)
	discarded_cards.map(_remove_card)
	_cards = []
	card_selection_changed.emit(false)
	return discarded_cards


func set_cards_clickable(clickable: bool) -> void:
	get_tree().call_group(CARDS_IN_PLAYER_HAND, "set_clickable", clickable)

#endregion
#region Private methods ##################################################################################

## Returns selected card, using Array[Card] because there's no optional return types
func _get_selected_card() -> Array[Card]:
	var selected_cards: Array[Card] = []
	for card in get_tree().get_nodes_in_group(CARDS_IN_PLAYER_HAND):
		if card.is_selected():
			selected_cards.append(card)

	assert(selected_cards.size() <= 1, "Only one card can be selected in PlayerHand")
	return selected_cards


func _remove_card(card: Card) -> void:
	_cards.erase(card)
	card.remove_from_group(CARDS_IN_PLAYER_HAND)
	remove_child(card)


## Checks for selected cards and prevents selecting additional
## cards if the number of selected cards is equal to [member PlayerHand.MAX_SELECTED]
func _on_card_clicked(clicked_card: Card) -> void:
	for card in get_tree().get_nodes_in_group(CARDS_IN_PLAYER_HAND):
		if card == clicked_card:
			continue

		if clicked_card.is_selected():
			card.set_selected(false)
			card.set_clickable(false)
		else:
			card.set_clickable(true)

	_position_all_cards()
	card_selection_changed.emit(_determine_selected_card_playable())


func _determine_selected_card_playable() -> bool:
	var selected_cards: Array[Card] = _get_selected_card()
	var one_card_selected: bool = selected_cards.size() == 1
	var stamina_cost_less_than_player_stamina: bool = false

	if one_card_selected:
		stamina_cost_less_than_player_stamina = selected_cards[0].get_stamina_cost() <= _stamina

	return one_card_selected and stamina_cost_less_than_player_stamina


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
	if card.is_selected():
		current_card_y -= 50

	card.position = Vector2(card_x, current_card_y)
	card.z_index = card_order


func _set_stamina(value: int) -> void:
	_stamina = value
	stamina_changed.emit(_stamina)

#endregion
#region Subclasses #######################################################################################


#endregion
