## Base resource for storing item stats
extends Resource
class_name Item

@export_group("Visual")
## Item's displayed name
@export var name: String = ""
## Item's displayed sprite
@export var sprite: AtlasTexture

@export_group("Stats")
## [CardAttributes] associated with item
@export var cards: Array[CardAttributes] = []
