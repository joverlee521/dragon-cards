class_name Card extends Area2D


@export var attributes: CardAttributes


func _ready():
	if attributes:
		if attributes.sprite:
			$CardImage.texture = attributes.sprite
