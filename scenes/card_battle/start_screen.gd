class_name CardBattleStartScreen extends CanvasLayer


var card_battle = load("res://scenes/card_battle/card_battle.tscn")
var player: Player
var enemies: Array[PackedScene] = []


func _ready():
	var slash = load("res://resources/cards/Slash.tres")
	var defend = load("res://resources/cards/Defend.tres")
	var big_hit = load("res://resources/cards/BigHit.tres")
	var shield_bash = load("res://resources/cards/ShieldBash.tres")
	var cards = [
		slash,
		slash,
		slash,
		defend,
		defend,
		big_hit,
		shield_bash
	]
	player = Player.new(load("res://resources/PlayerVocations/Warrior.tres"), cards)
	enemies = [
		load("res://scenes/enemies/Goblin.tscn"),
		load("res://scenes/enemies/GoblinKing.tscn")
	]


func start_battle():
	hide()
	var new_card_battle = card_battle.instantiate()
	new_card_battle.player = player
	new_card_battle.enemies = enemies
	new_card_battle.return_to_start_screen.connect(end_battle)
	add_child(new_card_battle)


func end_battle():
	remove_child($CardBattle)
	show()
