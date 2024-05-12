## Base resource for storing and calculating player vocation stats
extends Character
class_name Vocation

@export_group("Visual")
## Displayed vocation name
@export var vocation_name: String = ""
## Displayed vocation sprite
@export var vocation_sprite: AtlasTexture

@export_group("Stats")
## Max stamina per player turn in card battles
@export var max_stamina: int = 0
## Max hand size per player turn in card battles
@export var max_hand_size: int = 0
## Max discards per player turn in card battles
@export var max_discards: int = 0

@export_group("Equipment TYPES")
## [member Armor.ARMOUR_CLASS] allowed to be equipped
@export var armor_types: Array[Armor.ARMOR_CLASS]
## [member Weapon.WEAPON_CLASS] allowed to be equipped to the right hand
@export var right_hand_weapon_types: Array[Weapon.WEAPON_CLASS]
## [member Weapon.WEAPON_CLASS] allowed to be equipped to the left hand
@export var left_hand_weapon_types: Array[Weapon.WEAPON_CLASS]
