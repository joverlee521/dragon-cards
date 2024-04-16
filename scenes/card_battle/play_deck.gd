class_name PlayDeck extends Deck


signal card_dealt(new_card: Card)


func _ready():
	super()
	# Uncomment for debugging
	for i in range(20):
		add_card(CardAttributes.new(i,i,i, load("res://art/cards/back01.png")))

	shuffle()


func deal_card() -> void:
	var new_card = card_scene.instantiate()
	var new_card_attr = remove_card(0)

	new_card.attributes = new_card_attr
	emit_signal("card_dealt", new_card)


func _on_cards_refreshed(cards: Array[CardAttributes]) -> void:
	cards.map(add_card)
