extends Node2D

signal cards_depleted

@export var image: CompressedTexture2D

var cards: Array[CardAttributes] = []


func _ready():
	if image != null:
		$DeckImage.texture = image

	if cards.is_empty():
		$DeckImage.hide()


func add_card(card) -> void:
	cards.append(card)
	$DeckImage.show()


func remove_card(card: Card) -> void:
	cards.erase(card)

	if cards.is_empty():
		$DeckImage.hide()
		cards_depleted.emit()


func shuffle() -> void:
	cards.shuffle()
