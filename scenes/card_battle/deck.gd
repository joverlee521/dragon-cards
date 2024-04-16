class_name Deck extends Node2D

signal cards_depleted
signal cards_peeked(cards: Array[Card])

@export var image: CompressedTexture2D
@export var card_scene: PackedScene

var cards: Array[CardAttributes] = []


func _ready():
	if image != null:
		$DeckImage.texture = image

	if cards.is_empty():
		$DeckImage.hide()

	# Uncomment for debugging
	#for i in range(10):
		#add_card(CardAttributes.new(i,i,i, load("res://art/cards/back01.png")))


func add_card(card: CardAttributes) -> void:
	cards.append(card)
	update_card_count()
	$DeckImage.show()


func remove_card(index: int) -> CardAttributes:
	var removed_card = cards.pop_at(index)

	if cards.is_empty():
		$DeckImage.hide()
		cards_depleted.emit()

	return removed_card


func peek_cards(num: int) -> void:
	var peeked_cards = []
	var card_attrs = cards.slice(0, num)
	for card_attr in card_attrs:
		var new_card = card_scene.instantiate()
		new_card.attributes = card_attr
		peeked_cards.append(new_card)

	emit_signal("cards_peeked", peeked_cards)


func peek_all_cards() -> void:
	peek_cards(len(cards))


func shuffle() -> void:
	cards.shuffle()


func update_card_count() -> void:
	$CardCount.text = str(len(cards))
