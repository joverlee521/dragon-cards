class_name DiscardDeck extends Deck


signal cards_refreshed(cards: Array[CardAttributes])


func _ready():
	super()


func refresh_cards() -> void:
	emit_signal("cards_refreshed", remove_all_cards())
