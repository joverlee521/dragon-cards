class_name CardBattleStartScreen extends CanvasLayer


var card_battle = load("res://scenes/card_battle/card_battle.tscn")


func _ready():
	pass # Replace with function body.


func start_battle():
	hide()
	add_child(card_battle.instantiate())
