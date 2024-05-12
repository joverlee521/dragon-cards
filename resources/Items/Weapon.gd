## Base resource for storing weapon stats
extends Item
class_name Weapon

## Weapon classification
##
## [br]Individual class effects TBD.
enum WEAPON_CLASS {LIGHT, MEDIUM, HEAVY, MAGIC, DEFENSE, NONE}

## Weapon damage type
##
## [br]Determines [member CardAttributes.damage_types] for the [member Weapon.cards]
## which will affect attack numbers based on
enum DAMAGE_TYPE {CUTTING, BLUNT, FIRE, ICE, LIGHTNING, WATER, LIGHT, DARK, DEFAULT}
