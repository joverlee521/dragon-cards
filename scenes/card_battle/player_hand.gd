class_name PlayerHand
extends PanelContainer
## Container for [Card]s that are in the player's hand

#region Signals ##########################################################################################

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
	get_tree().call_group(CARDS_IN_PLAYER_HAND, "set_clickable", clickable)

#endregion
#region Private methods ##################################################################################

func _on_card_released(card: Card) -> void:
	# TODO: play card if overlapping with enemy
	# TODO: play card if card outside of the player hand and applicable to player
	card.return_to_pre_dragging_position()


func _remove_card(card: Card) -> void:
	_cards.erase(card)
	card.remove_from_group(CARDS_IN_PLAYER_HAND)
	remove_child(card)


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


func _set_stamina(value: int) -> void:
	_stamina = value
	stamina_changed.emit(_stamina)

#endregion
#region Subclasses #######################################################################################


#endregion
