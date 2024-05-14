class_name CardBattle extends Node

signal return_to_start_screen
signal defeated_battle_enemies

var endless_mode: bool = false
var enemies: Array = [] # Array[Enemies]
var player: Player


func _ready():
	start_battle()


func start_battle():
	set_player_stat_labels()
	$PlayDeck.set_deck(player.cards)
	$DiscardDeck.remove_all_cards()
	$PlayerHand.set_player_hand(player.character)
	$EnemiesArena.enemies = enemies
	$EndBattleScreen.hide()
	$SkipPlayerTurnLabel.hide()
	await get_tree().create_timer(2.0).timeout
	deal_hand()


func set_player_stat_labels():
	$Health.text = "%s / %s" % [str(player.character.health), str(player.character.max_health)]
	$Defense.text = str(player.character.defense)


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
	#TODO: change this to the player position when there is a representation of the player
	player.character.card_battle_position = played_card.global_position
	played_card.attributes.set_card_player(player.character)

	var enemy_characters: Array[Character] = []
	for enemy: Enemy in $EnemiesArena.get_selected_enemies():
		enemy_characters.append(enemy.character)
	played_card.attributes.set_card_targets(enemy_characters)
	played_card.attributes.set_animation(played_card.play_card_animation)
	played_card.set_discard_deck($DiscardDeck.cards)
	played_card.set_play_card_deck($PlayDeck.cards)
	await played_card.attributes.play_card()
	set_player_stat_labels()
	$EnemiesArena.set_enemy_stat_labels()
	$EnemiesArena.check_enemies_health()

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


func _on_enemies_acted(enemy_card_attributes: Array[CardAttributes]):
	var targets: Array[Character] = [player.character]
	for enemy_card_attribute in enemy_card_attributes:
		var enemy_card: Card = $PlayDeck.card_scene.instantiate()
		enemy_card.get_node("CardBackground").hide()
		enemy_card.attributes = enemy_card_attribute
		enemy_card.attributes.set_card_targets(targets)
		enemy_card.attributes.set_animation(enemy_card.play_card_animation)
		add_child(enemy_card)
		await enemy_card.attributes.play_card()
		enemy_card.queue_free()
		$EnemiesArena.set_enemy_stat_labels()
		set_player_stat_labels()

	if player.character.health <= 0:
		$EndBattleScreen.player_defeated()


func _on_enemies_defeated():
	if not endless_mode:
		$EndBattleScreen.player_won()
	else:
		$EndBattleScreen.load_new_enemies()
		player.character.add_health(5)
		player.character.remove_all_defense()
		defeated_battle_enemies.emit()


func _on_new_battle() -> void:
	start_battle()


func _on_return_to_start_screen() -> void:
	return_to_start_screen.emit()
