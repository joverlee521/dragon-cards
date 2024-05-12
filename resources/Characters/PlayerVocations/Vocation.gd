class_name Vocation extends Character

enum ARMOR_TYPES {LIGHT, MEDIUM, HEAVY, MAGIC, NONE}
enum WEAPON_TYPES {LIGHT, MEDIUM, HEAVY, MAGIC, DEFENSE, NONE}
enum VOCATION_TYPES {WARRIOR, MAGE, CHANGELING, THIEF, SUMMONER}

@export_group("Vocation Info")
@export var vocation_name : String = ""
@export var vocation_sprite: AtlasTexture
@export var vocation_type : VOCATION_TYPES = VOCATION_TYPES.WARRIOR

@export_group("Vocation Stats")
@export var max_stamina : int = 0
@export var max_hand_size : int = 0
@export var max_discards : int = 0

@export_group("Vocation Equipment TYPES")
@export var armor_type : Array[ARMOR_TYPES] = []
@export var right_hand : Array[WEAPON_TYPES] = []
@export var left_hand : Array[WEAPON_TYPES] = []


func _init():
	super()
