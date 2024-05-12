class_name Player extends Resource


var character: Vocation
var cards: Array = [] # Array[CardAttributes]


func _init(vocation: Vocation, i_cards: Array): # i_cards: Array[CardAttributes]
	character = vocation
	character.init_health()
	cards = i_cards
