extends Node2D

@onready var cardDisplay = get_parent()
var target_scale = Vector2(0, 0)
var scale_speed = 20.0


@onready var damage_label = $Card/Damage
@onready var name_label = $Card/Name

@onready var card_sprite = $Card


func _ready() -> void:
	self.scale = Vector2(0, 0)  # Start hidden
	
	card_sprite.texture = load(cardDisplay.card.sprite)
	name_label.text = str(cardDisplay.card.card_name)
	damage_label.text = str(cardDisplay.card.damage, " dmg")
	adjust_position()


func _process(delta: float) -> void:
	self.scale = self.scale.lerp(target_scale, scale_speed * delta)

func show_tooltip():
	adjust_position()
	self.visible = true
	scale_speed = 20.0
	target_scale = Vector2(1, 1) / Vector2(cardDisplay.scale[0], cardDisplay.scale[1])


func adjust_position():
	var viewport_size = get_viewport().size
	var margin = 5
	var area_global_position = $Card/Area2D.global_position
	var area_size = $Card/Area2D.get_node("CollisionShape2D").shape.extents * 2

	# Calculate the edges of the tooltip
	var left_edge = area_global_position.x
	var right_edge = area_global_position.x + area_size.x
	var top_edge = area_global_position.y - (area_size.y/2)
	var bottom_edge = area_global_position.y + (area_size.y/2)

	# Adjust position to ensure the tooltip stays within the viewport
	if left_edge < margin:
		self.position.x += margin - left_edge
	elif right_edge > viewport_size.x - margin:
		self.position.x -= right_edge - (viewport_size.x - margin)

	if top_edge < margin:
		self.position.y = margin + area_size.y/4
	elif bottom_edge > viewport_size.y - margin:
		self.position.y -= bottom_edge - (viewport_size.y - margin)

func hide_tooltip():
	target_scale = Vector2(0, 0)
	scale_speed = 20.0
	# await get_tree().create_timer(0.3).timeout
	# self.visible = false
