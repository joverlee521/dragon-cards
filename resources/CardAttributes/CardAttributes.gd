## Base resource for storing and calculating card effects
extends Resource
class_name CardAttributes

enum TARGET_TYPE {SINGLE, GROUP}

@export_group("Stats")
## Card target type, whether card effects should affect single target or whole group
@export var target_type: TARGET_TYPE
## Card's base attack applied to [member Card.tagets]
@export var attack: int = 0
## Card's base defense applied to [member Card.card_player]
@export var defense: int = 0
## Card's base stamina cost to be played
@export var stamina_cost: int = 0
## Card's base damage type
@export var damage_type: Weapon.DAMAGE_TYPE = Weapon.DAMAGE_TYPE.CUTTING
## Card's base damage element
@export var damage_element: Weapon.DAMAGE_ELEMENT = Weapon.DAMAGE_ELEMENT.NONE

@export_group ("Vocation Specific Stats")
## Parry value used by specific player vocations
@export var parry: int = 0

@export_group("Visual")
@export var card_name : String
@export var card_background: AtlasTexture
@export var card_border: AtlasTexture
@export var card_art : AtlasTexture
@export var card_description_plate : AtlasTexture
@export var card_name_plate : AtlasTexture
@export var card_description : String

## [Character] who played the [Card]
var card_player: Character
## One or more [Character]s that are targeted by the played [Card]
var card_targets: Array[Character]

## Callback function to play an animation for card effects.
## [br]Expected to be an async function that takes two arguments:
## [br]1. A String that represents the animation name
## [br]2. A Vector2D position of where the animation should be played
var play_animation: Callable

## Sets the [member CardAttributes.card_player]
func set_card_player(i_card_player: Character) -> void:
	card_player = i_card_player

## Sets the [member CardAttributes.card_targets]
##
## [br] Includes assertions to verify the number of targets matches the [CardAttributes.target_type]
func set_card_targets(i_card_targets: Array[Character]) -> void:
	match target_type:
		TARGET_TYPE.SINGLE:
			assert(i_card_targets.size() == 1, "Can only set only one target")
		TARGET_TYPE.GROUP:
			assert(i_card_targets.size() >= 1, "Must set one or more targets")
		_:
			assert(false, "Unhandled target_type: %s" % target_type)

	card_targets = i_card_targets

## Set the [method CardAttributes.play_animation]
func set_animation(i_play_animation: Callable) -> void:
	play_animation = i_play_animation

## Plays card by calling [method CardAttributes.apply_effects_to_card_player]
## then [member CardAttributes.apply_effects_to_card_targets] if [member CardAttributes.card_targets]
## defined
func play_card():
	assert(card_player != null, "Must set card_player before calling play_card")
	await apply_effects_to_card_player()
	if card_targets:
		await apply_effects_to_card_targets()

## Add [member CardAttributes.defense] to the [member CardAttributes.card_player]
func apply_effects_to_card_player():
	if defense > 0:
		card_player.add_defense(defense)
		await play_animation.call(get_defense_animation_string(), card_player.card_battle_position)

## Remove defense then health from [member CardAttribute.card_targets]
## based on damage calculated by [method Character.calculate_damaage_num_by_damage_type]
func apply_effects_to_card_targets():
	if attack > 0:
		for target: Character in card_targets:
			var damage_num: int = target.calculate_damage_num_by_damage_type(attack, damage_type, damage_element)
			target.remove_defense_then_health(damage_num)
			await play_animation.call(get_attack_animation_string(), target.card_battle_position)

## Get the animation name for the attack animation
func get_attack_animation_string() -> String:
	#TODO: Uncomment after adding animation frame with <damage_type>_<damage_element> names
	#var damage_type_string: String = Weapon.DAMAGE_TYPE.keys()[damage_type]
	#var damage_element_string: String = Weapon.DAMAGE_ELEMENT.keys()[damage_element]
	#return "%s_%s" % [damage_type_string, damage_element_string]
	match damage_type:
		Weapon.DAMAGE_TYPE.NONE, Weapon.DAMAGE_TYPE.CUTTING, Weapon.DAMAGE_TYPE.BLUNT:
			return "PhysicalAttack"
		Weapon.DAMAGE_TYPE.MAGIC:
			return "Magic"
		_:
			assert(false, "Unknown damage_type: %s" % damage_type)
			return ""

## Get the animation name for the defense animation
func get_defense_animation_string() -> String:
	return "AddArmor"
