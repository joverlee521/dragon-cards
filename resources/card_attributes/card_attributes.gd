class_name CardAttributes
extends Resource
## Base resource for storing and calculating card effects

#region Signals ####################################################################################

## Emitted when the [CardAttributes] triggers an animation
signal triggered_animation(animation_name: String, animation_position: Vector2)

#endregion
#region Enums ######################################################################################

## Options for the [member CardAttributes.target_type]
enum TARGET_TYPE {
	## Card only attacks a single target
	SINGLE,
	## Card attacks groups of targets
	GROUP,
}

#endregion
#region Constants ##################################################################################


#endregion
#region @export variables ##########################################################################

@export_group("Card Visual")
## Displayed card name
@export var card_name : String = ""
## Displayed card background
@export var card_background: AtlasTexture
## Displayed card border
@export var card_border: AtlasTexture
## Displayed card art
@export var card_art : AtlasTexture
## Displayed background for the card description
@export var card_description_plate : AtlasTexture
## Displayed background for the card name
@export var card_name_plate : AtlasTexture
## Displayed card description
@export var card_description : String = ""

@export_group("Card Stats")
## Card's [enum CardAttributes.TARGET_TYPE] for affectting owners
## [br] SINGLE = only affect the owner of the card
## [br] GROUP = affect owner and the owner team
@export var owner_target_type: TARGET_TYPE = TARGET_TYPE.SINGLE
## Card's [enum CardAttributes.TARGET_TYPE] for affecting opposers
## [br] SINGLE = only affect the opposer
## [br] GROUP = affect the opposer and the opposer team
@export var opposer_target_type: TARGET_TYPE = TARGET_TYPE.SINGLE
## Card's base attack damage
@export var attack: int = 0
## Card's base defense added
@export var defense: int = 0
## Card's base stamina cost to be played
@export var stamina_cost: int = 0
## Card's base damage type
@export var damage_type: Weapon.DAMAGE_TYPE = Weapon.DAMAGE_TYPE.NONE
## Card's base damage element
@export var damage_element: Weapon.DAMAGE_ELEMENT = Weapon.DAMAGE_ELEMENT.NONE
## Card's status effects applied to the card player
@export var status_effects_on_card_player: Array[StatusEffect]
## Card's status effects applied to the card target
@export var status_effects_on_card_target: Array[StatusEffect]

#endregion
#region Public variables ###########################################################################


#endregion
#region Private variables ##########################################################################


#endregion
#region @onready variables #########################################################################


#endregion
#region Optional _init method ######################################################################


#endregion
#region Optional _enter_tree() method ##############################################################


#endregion
#region Optional _ready method #####################################################################


#endregion
#region Optional remaining built-in virtual methods ################################################


#endregion
#region Public methods #############################################################################

## Apply [CardAttributes]'s effects to the [param card_affectees].
## Optionally, the [param _card_env] can change the [CardAttributes]'s effects
func apply_effects(card_affectees: CardAffectees, _card_env: CardEnvironment) -> void:
	apply_defense(card_affectees.owner)
	if owner_target_type == TARGET_TYPE.GROUP:
		for target in card_affectees.owner_team:
			apply_defense(target)

	apply_attack(card_affectees.opposer)
	if opposer_target_type == TARGET_TYPE.GROUP:
		for target in card_affectees.opposer_team:
			apply_attack(target)


func apply_attack(target: CardTarget) -> void:
	if attack > 0:
		triggered_animation.emit(_get_attack_animation_string(), target.global_position)
		target.character.take_damage(attack)


func apply_defense(target: CardTarget) -> void:
	if defense > 0:
		triggered_animation.emit(_get_defense_animation_string(), target.global_position)
		target.character.add_defense(defense)

#endregion
#region Private methods ############################################################################

## Get the animation name for the attack animation
func _get_attack_animation_string() -> String:
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
func _get_defense_animation_string() -> String:
	return "AddArmor"

#endregion
#region Subclasses #################################################################################

## The base class representing a [CardAttributes]'s target
class CardTarget:
	var character: Character = Character.new()
	var global_position: Vector2 = Vector2(0,0)

	func _init(i_character: Character, i_global_position: Vector2) -> void:
		character = i_character
		global_position = i_global_position


## The base class representing all of the relations of a [CardAttributes]'s targets
class CardAffectees:
	var owner: CardTarget
	var owner_team: Array[CardTarget]
	var opposer: CardTarget
	var opposer_team: Array[CardTarget]

	func _init(i_owner: CardTarget,
			   i_owner_team: Array[CardTarget],
			   i_opposer: CardTarget,
			   i_opposer_team: Array[CardTarget]) -> void:
		owner = i_owner
		owner_team = i_owner_team
		opposer = i_opposer
		opposer_team = i_opposer_team


## The base class representing environmental factors
## that can change a [CardAttributes]'s effects
class CardEnvironment:
	var play_deck_cards: Array[CardAttributes] = []
	var discard_deck_cards: Array[CardAttributes] = []

	func _init(i_play_deck_cards: Array[CardAttributes],
			   i_discard_deck_cards: Array[CardAttributes]) -> void:
		play_deck_cards = i_play_deck_cards
		discard_deck_cards = i_discard_deck_cards

#endregion