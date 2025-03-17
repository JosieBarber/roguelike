extends Node2D

@onready var cardDisplay = get_parent()

func _ready() -> void:
	self.scale = Vector2(1, 1)

func show_tooltip():
	self.visible = true
	scale = Vector2(1,1) / Vector2(cardDisplay.scale[0], cardDisplay.scale[1])


func hide_tooltip():
	self.visible = false
