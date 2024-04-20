class_name EndBattleScreen extends ColorRect


func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	$EndState.text = ""
	self.hide()


func _on_player_defeated():
	self.show()
	$EndState.text = "YOU LOSE"


func _on_all_enemies_defeated():
	self.show()
	$EndState.text = "YOU WIN"
