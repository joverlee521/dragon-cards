class_name DiscardDeck extends Deck


signal cards_refreshed(cards) # cards: : Array[CardAttributes]


func _ready():
	super()


func refresh_cards() -> void:
	emit_signal("cards_refreshed", remove_all_cards())


func _on_cards_discarded(cards: Array[CardAttributes]) -> void:
	cards.map(add_card)
