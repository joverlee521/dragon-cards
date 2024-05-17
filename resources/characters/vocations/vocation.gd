class_name Vocation
extends Resource
## Base resource for storing and vocation stats

@export_group("Vocation Visual")
## Displayed vocation name
@export var vocation_name: String = ""
## Displayed vocation sprite
@export var vocation_sprite: AtlasTexture

@export_group("Vocation Stats")
## Vocation's max health
@export var max_health: int = 0
## Vocation's starting defense
@export var starting_defense: int = 0
