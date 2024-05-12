class_name PlayDeck extends Deck


signal card_dealt(new_card: Card)


func _ready():
	super()


func set_deck(cards) -> void:
	remove_all_cards()
	cards.map(add_card)
	shuffle()


func deal_card() -> void:
	if len(cards) == 0:
		return
	var new_card = card_scene.instantiate()
	var new_card_attr = remove_card(0)

	new_card.attributes = new_card_attr
	emit_signal("card_dealt", new_card)


func _on_cards_refreshed(cards) -> void: # cards: : Array[CardAttributes]
	set_deck(cards)