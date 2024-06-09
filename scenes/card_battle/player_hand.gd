class_name PlayerHand
extends PanelContainer
## Container for [Card]s that are in the player's hand

#region Signals ##########################################################################################

## Emitted when a [Card] is dragged and dropped
signal drag_and_dropped_card(card: Card)

## Emitted whenever the [member PlayerHand._current_stamina] changes in value
signal stamina_changed(new_value: int)

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
	card.card_released.connect(_on_card_released)
	_cards.append(card)
	add_child(card)
	card.add_to_group(CARDS_IN_PLAYER_HAND)
	_position_all_cards()


func discard_all_cards() -> Array[Card]:
	var discarded_cards: Array[Card] = _cards.duplicate(true)
	discarded_cards.map(_remove_card)
	_cards = []
	return discarded_cards


func set_cards_clickable(clickable: bool) -> void:
	for card in _cards:
		# Always deactivate cards that cost more than the available stamina
		if card.get_stamina_cost() > _stamina:
			card.set_clickable(false)
		else:
			card.set_clickable(clickable)


func play_card(card: Card) -> void:
	set_cards_clickable(false)
	var stamina_cost: int = card.get_stamina_cost()
	assert(stamina_cost <= _stamina, "Unable to play card with higher stamina cost than remaining stamina")
	_stamina -= stamina_cost

	_remove_card(card, [get_parent()])
	_position_all_cards()
	set_cards_clickable(true)


func reposition_all_cards() -> void:
	_position_all_cards()


#endregion
#region Private methods ##################################################################################

func _on_card_released(card: Card) -> void:
	drag_and_dropped_card.emit(card)


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
	card.position = Vector2(card_x, current_card_y)
	card.z_index = card_order


func _remove_card(card: Card, new_parent: Array = []) -> void:
	_cards.erase(card)
	card.remove_from_group(CARDS_IN_PLAYER_HAND)
	if new_parent.size() == 1:
		card.reparent(new_parent[0])
	else:
		remove_child(card)


func _set_stamina(value: int) -> void:
	_stamina = value
	stamina_changed.emit(_stamina)

#endregion
#region Subclasses #######################################################################################


#endregion
