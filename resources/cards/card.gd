class_name CardAttributes extends Resource

@export_group("Stats")
@export var attack: int
@export var defense: int
@export var stamina_cost: int

@export_group("Visual")
@export var sprite: CompressedTexture2D


func _init(i_attack = 0, i_defense = 0, i_stamina_cost = 0,
		   i_sprite = load("res://art/cards/back01.png")):
	attack = i_attack
	defense = i_defense
	stamina_cost = i_stamina_cost
	sprite = i_sprite
