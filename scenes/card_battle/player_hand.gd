class_name PlayerHand extends ColorRect


signal hand_full
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
var max_stamina: int = 5
var current_stamina: int = 5:
	set(value):
		current_stamina = value
		set_play_card_button()
		$Stamina.text = "%s / %s" % [str(current_stamina), str(max_stamina)]


func _ready():
	# Ignore mouse events here so the individual cards can be clicked
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_y = get_rect().size.y/2
	set_card_x_spacing()
	set_play_card_button()
	$DiscardCard.set_disabled(true)
	$Stamina.text = "%s / %s" % [str(current_stamina), str(max_stamina)]


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
	$PlayCard.set_disabled(true)
	$DiscardCard.set_disabled(true)
	var selected_cards = get_selected_cards()
	for card in selected_cards:
		cards.erase(card)
		remove_child(card)

	position_all_cards()
	emit_signal("cards_selected", false)
	return selected_cards


func get_selected_cards() -> Array[Card]:
	return cards.filter(func(card): return card.is_selected)


func get_selected_cards_stamina_cost() -> int:
	var selected_cards = get_selected_cards()
	return selected_cards.reduce(func(accum, card): return accum + card.attributes.stamina_cost, 0)


func set_play_card_button() -> void:
	if current_stamina == 0:
		$PlayCard.set_disabled(true)
	elif len(get_selected_cards()) == 0:
		$PlayCard.set_disabled(true)
	elif get_selected_cards_stamina_cost() > current_stamina:
		$PlayCard.set_disabled(true)
	else:
		$PlayCard.set_disabled(false)


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
	$DiscardCard.set_disabled(selected_cards.is_empty())

	position_all_cards()
	emit_signal("cards_selected", len(selected_cards) == max_selected)


func _on_play_cards():
	var stamina_cost = get_selected_cards_stamina_cost()
	assert(stamina_cost <= current_stamina, "Cards cost more stamina than current stamina")
	current_stamina -= stamina_cost

	var selected_cards = remove_selected_cards()
	emit_signal("cards_played", selected_cards)


func _on_discard_cards():
	var selected_cards = remove_selected_cards()
	emit_signal("cards_discarded", selected_cards)

