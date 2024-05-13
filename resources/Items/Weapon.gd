## Base resource for storing weapon stats
extends Item
class_name Weapon

## Weapon classification
##
## [br]Individual class effects TBD.
enum WEAPON_CLASS {LIGHT, MEDIUM, HEAVY, MAGIC, DEFENSE, NONE}

## Weapon damage type
##
## [br]Determines [member CardAttributes.damage_type] for the [member Weapon.cards]
enum DAMAGE_TYPE {NONE, CUTTING, BLUNT, MAGIC}

## Weapon damage element
##
## [br]Determines [member CardAttributes.damage_element] for the [member Weapon.cards]
enum DAMAGE_ELEMENT {NONE, FIRE, ICE, LIGHTNING, WATER, LIGHT, DARK}
