class_name EndBattleScreen extends CanvasLayer


func _ready():
	$EndBattleBackground.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$EndState.text = ""
	self.hide()


func player_defeated():
	$NewBattle.show()
	$ReturnToStartScreen.show()
	self.show()
	$EndState.text = "YOU LOSE"


func player_won():
	$NewBattle.show()
	$ReturnToStartScreen.show()
	self.show()
	$EndState.text = "YOU WIN"


func load_new_enemies():
	$NewBattle.hide()
	$ReturnToStartScreen.hide()
	self.show()
	$EndState.text = "YOU WIN \n LOADING NEW ENEMIES"
