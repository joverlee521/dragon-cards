class_name CardBattleStartScreen extends CanvasLayer


var card_battle = load("res://scenes/card_battle/card_battle.tscn")


func _ready():
	pass # Replace with function body.


func start_battle():
	hide()
	var new_card_battle = card_battle.instantiate()
	new_card_battle.return_to_start_screen.connect(end_battle)
	add_child(new_card_battle)


func end_battle():
	remove_child($CardBattle)
	show()
