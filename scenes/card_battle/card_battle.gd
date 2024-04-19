class_name CardBattle extends Node

@export_group("CardBattleStats")
@export var enemies: Array[PackedScene] = []
@export var battle_hand_size: int = 7


func _ready():
	$PlayerHand.max_hand_size = battle_hand_size
	$EnemiesArena.enemies = enemies
	await get_tree().create_timer(2.0).timeout
	deal_hand()


func deal_hand() -> void:
	deal_cards(battle_hand_size)


func deal_cards(num: int) -> void:
	for n in range(num):
		await get_tree().create_timer(0.2).timeout
		$PlayDeck.deal_card()


func _on_cards_played(cards: Array[Card]) -> void:
	assert(len(cards) == 1, "Can only play one card")
	var played_card = cards[0]
	add_child(played_card)
	played_card.position = $PlayedCard.position
	var attack = played_card.attributes.get('attack')
	if attack:
		$EnemiesArena.attack_enemies(attack)

	await get_tree().create_timer(1.0).timeout

	$DiscardDeck.add_card(played_card.attributes)
	played_card.queue_free()

	deal_cards(1)


func _on_cards_discarded(cards: Array[Card]) -> void:
	assert(len(cards) == 1, "Can only discard one card")
	var discarded_card = cards[0]

	$DiscardDeck.add_card(discarded_card.attributes)
	discarded_card.queue_free()

	deal_cards(1)
