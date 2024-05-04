class_name CardBattle extends Node

@export_group("CardBattleStats")
@export var enemies: Array[PackedScene] = []

@export_group("PlayerStats")
@export var player_vocation: Vocation
@export var player_cards: Array[CardAttributes] = []

var player: Character


func _ready():
	start_battle()


func start_battle():
	# TODO: track player's actual health
	player = Character.new(player_vocation.max_health, 0, set_player_stat_labels)
	set_player_stat_labels()
	$PlayDeck.set_deck(player_cards)
	$DiscardDeck.remove_all_cards()
	$PlayerHand.set_player_hand(player_vocation)
	$EnemiesArena.enemies = enemies
	$EndBattleScreen.hide()
	$SkipPlayerTurnLabel.hide()
	await get_tree().create_timer(2.0).timeout
	deal_hand()


func set_player_stat_labels():
	$Health.text = "%s / %s" % [str(player.health), str(player.max_health)]
	$Defense.text = str(player.defense)


func deal_hand() -> void:
	deal_cards($PlayerHand.max_hand_size)


func deal_cards(num: int) -> void:
	for n in range(num):
		await get_tree().create_timer(0.2).timeout
		$PlayDeck.deal_card()


func skip_player_turns(num: int) -> void:
	$SkipPlayerTurnLabel.show()

	for i in range(num):
		await get_tree().create_timer(1.0).timeout
		$EnemiesArena.enemies_move()

	$SkipPlayerTurnLabel.hide()
	deal_hand()


func _on_cards_played(cards: Array[Card]) -> void:
	assert(len(cards) == 1, "Can only play one card")
	var played_card = cards[0]
	add_child(played_card)
	played_card.position = $PlayedCard.position

	player.add_defense(played_card.attributes.defense)
	$EnemiesArena.attack_enemies(played_card.attributes.attack)

	#Suggestion for handling more complex card effects
	#played_card.do_effects(self)

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


func _on_player_turn_ended() -> void:
	if ($PlayDeck.cards.is_empty() and $PlayerHand.cards.is_empty()):
		$DiscardDeck.refresh_cards()
		skip_player_turns(1)
	else:
		$EnemiesArena.enemies_move()

	$PlayerHand.is_player_turn = true


func _on_enemies_acted(enemy_moves): # enemy_moves: Array[CardAttributes]
	var total_attack = enemy_moves.reduce(func(accum, move): return accum + move.attack, 0)
	player.remove_health(total_attack)
	if player.health <= 0:
		$EndBattleScreen.player_defeated()


func _on_new_battle() -> void:
	start_battle()
