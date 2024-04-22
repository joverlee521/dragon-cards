class_name CardAttributes extends Resource

enum DAMAGE_TYPES {CUTTING, BLUNT, FIRE, ICE, LIGHTNING, WATER, LIGHT, DARK, DEFAULT}

enum TARGET_TYPES {SINGLE, GROUP}

@export_group("CardInfo")
@export var name : String
#Consider making type into an enum for categorization. Spell, Physical, Armor e.g.
@export var DamageTypes : Array[DAMAGE_TYPES]

@export var Target : TARGET_TYPES

@export_group("Stats")
@export var attack: int
@export var defense: int
@export var stamina_cost: int

@export_group ("Class Stats")
@export var parry_value : int

@export_group("Visual")
@export var card_background: AtlasTexture
@export var card_border: AtlasTexture
@export var card_art : AtlasTexture
@export var card_description_plate : AtlasTexture
@export var card_name_plate : AtlasTexture
@export var card_description : String
@export var card_name : String


func _init(i_attack = 0, i_defense = 0, i_stamina_cost = 0):
	attack = i_attack
	defense = i_defense
	stamina_cost = i_stamina_cost
