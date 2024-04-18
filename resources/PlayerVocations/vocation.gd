class_name Vocation extends Resource

enum ARMOR_TYPES {LIGHT, MEDIUM, HEAVY, MAGIC, NONE}
enum WEAPON_TYPES {LIGHT, MEDIUM, HEAVY, MAGIC, DEFENSE, NONE}
enum VOCATION_TYPES {WARRIOR, MAGE, CHANGELING, THIEF, SUMMONER}

@export_group("VocationInfo")
@export var vocation_name : String
@export var vocation_sprite: AtlasTexture
@export var vocation_type : VOCATION_TYPES

@export_group("VocationStats")
@export var max_health : int
@export var max_stamina : int
@export var max_hand_size : int
@export var max_discards : int

@export_group("VocationEquipmentTYPES")
@export var armor_type : Array[ARMOR_TYPES]
@export var right_hand : Array[WEAPON_TYPES]
@export var left_hand : Array[WEAPON_TYPES]
