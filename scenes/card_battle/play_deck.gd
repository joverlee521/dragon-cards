class_name PlayDeck extends Deck


signal card_dealt(new_card: Card)


func _ready():
	super()


func deal_card() -> void:
	var new_card = card_scene.instantiate()
	var new_card_attr = remove_card(0)

	new_card.attributes = new_card_attr
	emit_signal("card_dealt", new_card)
