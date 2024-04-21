class_name PlayerHand extends ColorRect

signal player_defeated
signal player_turn_ended
signal cards_selected(max_cards_selected: bool)
signal cards_played(cards: Array[Card])
signal cards_discarded(cards: Array[Card])

# Card arrangements
const max_selected: int = 1
var card_y: int
var card_x_spacing: int
var max_hand_size: int:
	set(value):
		max_hand_size = value
		set_card_x_spacing()
var cards: Array[Card] = []

# Player stats
var is_player_turn: bool = true:
	set(value):
		is_player_turn = value
		set_play_card_button()
		set_discard_card_button()
		$EndTurn.set_disabled(!is_player_turn)

var defense: int = 0:
	set(value):
		defense = value
		if is_node_ready():
			$Defense.text = str(defense)
var max_health: int = 10
var remaining_health: int = max_health:
	set(value):
		remaining_health = value
		$Health.text = "%s / %s" % [str(remaining_health), str(max_health)]
		if remaining_health <= 0:
			player_defeated.emit()

var max_stamina: int = 5
var remaining_stamina: int = max_stamina:
	set(value):
		remaining_stamina = value
		set_play_card_button()
		$Stamina.text = "%s / %s" % [str(remaining_stamina), str(max_stamina)]
var max_discards: int = 3
var remaining_discards: int = max_discards:
	set(value):
		remaining_discards = value
		set_discard_card_button()
		$Discard.text = "%s / %s" % [str(remaining_discards), str(max_discards)]


func _ready():
	# Ignore mouse events here so the individual cards can be clicked
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_y = get_rect().size.y/2
	set_card_x_spacing()
	set_play_card_button()
	set_discard_card_button()
	$Defense.text = str(defense)
	$Health.text = "%s / %s" % [str(remaining_health), str(max_health)]
	$Stamina.text = "%s / %s" % [str(remaining_stamina), str(max_stamina)]
	$Discard.text = "%s / %s" % [str(remaining_discards), str(max_discards)]


func set_card_x_spacing() -> void:
	card_x_spacing = size.x/(max_hand_size + 1)


func position_card(card, card_order) -> void:
	var card_x = card_order * card_x_spacing

	var current_card_y = card_y
	if card.is_selected:
		current_card_y -= 50

	card.position = Vector2(card_x, current_card_y)
	card.z_index = card_order


func position_all_cards() -> void:
	for i in len(cards):
		var card = cards[i]
		position_card(card, i+1)


func remove_selected_cards() -> Array[Card]:
	var selected_cards = get_selected_cards()
	for card in selected_cards:
		cards.erase(card)
		remove_child(card)

	set_play_card_button()
	set_discard_card_button()
	position_all_cards()
	emit_signal("cards_selected", false)
	return selected_cards


func get_selected_cards() -> Array[Card]:
	return cards.filter(func(card): return card.is_selected)


func get_selected_cards_stamina_cost() -> int:
	var selected_cards = get_selected_cards()
	return selected_cards.reduce(func(accum, card): return accum + card.attributes.stamina_cost, 0)


func set_play_card_button() -> void:
	if remaining_stamina == 0:
		$PlayCard.set_disabled(true)
	elif len(get_selected_cards()) == 0:
		$PlayCard.set_disabled(true)
	elif get_selected_cards_stamina_cost() > remaining_stamina:
		$PlayCard.set_disabled(true)
	elif !is_player_turn:
		$PlayCard.set_disabled(true)
	else:
		$PlayCard.set_disabled(false)


func set_discard_card_button() -> void:
	if remaining_discards == 0:
		$DiscardCard.set_disabled(true)
	elif len(get_selected_cards()) == 0:
		$DiscardCard.set_disabled(true)
	elif !is_player_turn:
		$PlayCard.set_disabled(true)
	else:
		$DiscardCard.set_disabled(false)


func _on_deck_dealt_card(new_card):
	cards.append(new_card)
	new_card.hide()
	add_child(new_card)

	# 2-way signal connection to prevent selecting more cards than the max_selected
	new_card.card_clicked.connect(_on_card_clicked)
	self.cards_selected.connect(new_card._on_cards_selected)

	position_all_cards()
	new_card.show()


func _on_card_clicked():
	var selected_cards = get_selected_cards()
	set_play_card_button()
	set_discard_card_button()

	position_all_cards()
	emit_signal("cards_selected", len(selected_cards) == max_selected)


func _on_play_cards():
	var stamina_cost = get_selected_cards_stamina_cost()
	assert(stamina_cost <= remaining_stamina, "Cards cost more stamina than current stamina")
	remaining_stamina -= stamina_cost

	var selected_cards = remove_selected_cards()
	defense += selected_cards.reduce(func(accum, card): return accum + card.attributes.defense, 0)
	emit_signal("cards_played", selected_cards)


func _on_discard_cards():
	assert(remaining_discards != 0, "Out of available discards")
	var selected_cards = remove_selected_cards()
	remaining_discards -= len(selected_cards)
	emit_signal("cards_discarded", selected_cards)


func _on_end_turn():
	remaining_discards = max_discards
	remaining_stamina = max_stamina
	is_player_turn = false
	player_turn_ended.emit()


func _on_enemies_acted(enemy_moves): # enemy_moves: Array[CardAttributes]
	var total_attack = enemy_moves.reduce(func(accum, move): return accum + move.attack, 0)

	if total_attack >= defense:
		total_attack -= defense
		defense = 0
	else:
		defense -= total_attack
		total_attack = 0

	remaining_health -= total_attack
