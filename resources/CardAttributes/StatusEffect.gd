extends Resource
class_name StatusEffect

@export_enum("poison", "freeze", "knockout", "burn") var status_effect_name: String
@export var applied_number: int = 0
