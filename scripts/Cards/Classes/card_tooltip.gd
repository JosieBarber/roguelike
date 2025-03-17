extends Node2D

@onready var cardDisplay = get_parent()
var target_scale = Vector2(0, 0)
var scale_speed = 20.0

func _ready() -> void:
	self.scale = Vector2(0, 0)  # Start hidden

func _process(delta: float) -> void:
	self.scale = self.scale.lerp(target_scale, scale_speed * delta)

func show_tooltip():
	self.visible = true
	scale_speed = 20.0
	target_scale = Vector2(1, 1) / Vector2(cardDisplay.scale[0], cardDisplay.scale[1])

func hide_tooltip():
	target_scale = Vector2(0, 0)
	scale_speed = 20.0
	# await get_tree().create_timer(0.3).timeout
	# self.visible = false
