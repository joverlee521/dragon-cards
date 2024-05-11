class_name CardBattle extends Node

signal return_to_start_screen
signal defeated_battle_enemies

var endless_mode: bool = false
var enemies: = [] # Array[Enemies]
var player: Player


func _ready():
	start_battle()


func start_battle():
	$CardAnimation.hide()
	player.set_player_stats_label_function(set_player_stat_labels)
	set_player_stat_labels()
	$PlayDeck.set_deck(player.cards)
	$DiscardDeck.remove_all_cards()
	$PlayerHand.set_player_hand(player.vocation)
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
	player.character.card_battle_position = played_card.position
	played_card.attributes.set_card_player(player.character)

	var enemy_characters = $EnemiesArena.get_selected_enemies().map(func(enemy): return enemy.character)
	played_card.attributes.set_card_targets(enemy_characters)
	played_card.attributes.set_animation(play_card_animation)
	played_card.attributes.play_card()
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


func _on_enemies_acted(enemy_cards): # enemy_moves: Array[CardAttributes]
	for enemy_card in enemy_cards:
		enemy_card.set_card_targets([player.character])
		enemy_card.set_animation(play_card_animation)
		enemy_card.play_card()

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
	
func play_card_animation(animation_name : String, animation_location : Vector2):
	#var local_animation_location = to_local(animation_location)
	$CardAnimation.position = animation_location
	$CardAnimation.show()
	print(animation_name)
	$CardAnimation.play(animation_name)


func _on_card_animation_finished():
	$CardAnimation.hide()
