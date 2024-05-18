class_name Item
extends Resource
## Base resource for storing item stats

@export_group("Item Visual")
## Item's displayed name
@export var name: String = ""
## Item's displayed sprite
@export var sprite: AtlasTexture

@export_group("Cards")
## [CardAttributes] associated with item
@export var card_attributes: Array[CardAttributes] = []
