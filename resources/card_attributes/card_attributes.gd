class_name CardAttributes
extends Resource
## Base resource for storing and calculating card effects

#region Signals ####################################################################################

## Emitted when the [CardAttributes] triggers an animation
signal triggered_animation(animation_name: String, animation_position: Vector2)

#endregion
#region Enums ######################################################################################

## Options for the [member CardAttributes.affectee_type]
enum AFFECTEE_TYPE {
	OWNER_ONLY,
	OPPOSER_ONLY,
	OWNER_THEN_OPPOSER,
	OPPOSER_THEN_OWNER
}

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
## Card's [enum CardAttributes.AFFECTEE_TYPE] for which targets are affected by the card
## [br] OWNER_ONLY = only affects the owner/owner team of the card
## [br] OPPOSER_ONLY = only affects the opposer/opposer team of the card
## [br] OWNER_THEN_OPPOSER = affects owner/owner team then the opposer/opposer team
## [br] OPPOSER_THEN_OWNER = affects the opposer/opposer team then the owner/owner team
@export var affectee_type: AFFECTEE_TYPE = AFFECTEE_TYPE.OPPOSER_ONLY
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
## Card's status effects applied to the owner/owner team
@export var status_effects_on_owner: Array[StatusEffect] = []
## Card's status effects applied to the opposer/opposer team
@export var status_effects_on_opposer: Array[StatusEffect] = []

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

	match affectee_type:
		AFFECTEE_TYPE.OWNER_ONLY:
			apply_effects_to_owner(card_affectees, _card_env)
		AFFECTEE_TYPE.OPPOSER_ONLY:
			apply_effects_to_opposer(card_affectees, _card_env)
		AFFECTEE_TYPE.OWNER_THEN_OPPOSER:
			apply_effects_to_owner(card_affectees, _card_env)
			apply_effects_to_opposer(card_affectees, _card_env)
		AFFECTEE_TYPE.OPPOSER_THEN_OWNER:
			apply_effects_to_opposer(card_affectees, _card_env)
			apply_effects_to_owner(card_affectees, _card_env)
		_:
			assert(false, "Encountered unsupported affectee_type: %s" % affectee_type)


func apply_effects_to_owner(card_affectees: CardAffectees, _card_env: CardEnvironment) -> void:
	apply_defense(card_affectees.owner)
	apply_status_effects(card_affectees.owner, status_effects_on_owner)
	if owner_target_type == TARGET_TYPE.GROUP:
		for target in card_affectees.owner_team:
			apply_defense(target)
			apply_status_effects(target, status_effects_on_owner)


func apply_effects_to_opposer(card_affectees: CardAffectees, _card_env: CardEnvironment) -> void:
	apply_attack(card_affectees.opposer)
	apply_status_effects(card_affectees.opposer, status_effects_on_opposer)
	if opposer_target_type == TARGET_TYPE.GROUP:
		for target in card_affectees.opposer_team:
			apply_attack(target)
			apply_status_effects(target, status_effects_on_opposer)


func apply_attack(target: CardTarget, ignore_defense: bool = false) -> void:
	if attack > 0:
		triggered_animation.emit(_get_attack_animation_string(), target.global_position)
		target.character.take_damage(attack, damage_element, ignore_defense)


func apply_defense(target: CardTarget) -> void:
	if defense > 0:
		triggered_animation.emit(_get_defense_animation_string(), target.global_position)
		target.character.add_defense(defense)


func apply_status_effects(target: CardTarget, status_effects: Array[StatusEffect]) -> void:
	if status_effects.size() > 0:
		# TODO: Add animation for applying status effects?
		target.character.add_status_effects(status_effects)


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
			   i_owner_team: Array[CardTarget]  = [],
			   i_opposer: CardTarget = null,
			   i_opposer_team: Array[CardTarget] = []) -> void:
		owner = i_owner
		owner_team = i_owner_team
		opposer = i_opposer
		opposer_team = i_opposer_team


## The base class representing environmental factors
## that can change a [CardAttributes]'s effects
class CardEnvironment:
	var play_deck: Deck
	var discard_deck: Deck

	func _init(i_play_deck: Deck,
			   i_discard_deck: Deck) -> void:
		play_deck = i_play_deck
		discard_deck = i_discard_deck

#endregion
