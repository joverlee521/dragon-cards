## Resource for storing player stats
extends Resource
class_name Player

## [Vocation] player has chosen for expedition
var character: Vocation
## [CardAttributes] the player has equipped [br]TODO: Replace with items
var cards: Array[CardAttributes] = []


func _init(vocation: Vocation, i_cards: Array[CardAttributes]) -> void:
	character = vocation
	character.init_health()
	cards = i_cards
