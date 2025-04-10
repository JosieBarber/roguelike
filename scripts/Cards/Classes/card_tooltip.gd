extends Node2D

@onready var cardDisplay = get_parent().get_parent()
var target_scale = Vector2(0, 0)
var scale_speed = 20.0


#@onready var damage_label = $Card/Damage
@onready var name_labels = [$TooltipRight/Name,$TooltipLeft/Name]
@onready var effect_labels = [$TooltipRight/Effect,$TooltipLeft/Effect]

@onready var card_sprite = $Card


func _ready() -> void:
	cardDisplay.connect("tree_exited", Callable(self, "_on_card_display_tree_exited"))
	self.scale = Vector2(0, 0)  # Start hidden
	self.position = cardDisplay.global_position
	card_sprite.texture = load(cardDisplay.card.sprite)
	for label in name_labels:
		label.text = str(cardDisplay.card.card_name)
	for label in effect_labels:
		label.text = str(cardDisplay.card.effect)
	#name_label.text = str(cardDisplay.card.card_name)
	#effect.text = str(cardDisplay.card.effect)
	#damage_label.text = str(cardDisplay.card.damage, " dmg")
	adjust_position()


func _process(delta: float) -> void:
	self.scale = self.scale.lerp(target_scale, scale_speed * delta)
	self.position = cardDisplay.global_position

func show_tooltip():
	adjust_position()
	self.visible = true
	scale_speed = 20.0
	#target_scale = Vector2(1, 1) / Vector2(cardDisplay.scale[0], cardDisplay.scale[1])
	target_scale = Vector2(1,1)


func adjust_position():
	var viewport_rect = get_viewport().get_visible_rect()
	var viewport_size = viewport_rect.size
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

	# Switch tooltip side based on position relative to the middle of the screen
	var screen_middle = viewport_size.x / 2
	if self.global_position.x > screen_middle:
		$TooltipRight.visible = false
		$TooltipLeft.visible = true
	else:
		$TooltipRight.visible = true
		$TooltipLeft.visible = false

func hide_tooltip():
	target_scale = Vector2(0, 0)
	scale_speed = 20.0
	# await get_tree().create_timer(0.3).timeout
	# self.visible = false
	
func _on_card_display_tree_exited():
	queue_free()
