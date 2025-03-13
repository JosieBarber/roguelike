extends Node2D

class_name CardDisplay

signal card_clicked(card, parent_node)

var card: Card
var hoverable: bool

func _ready():
	var area = $Area2D
	if area == null:
		pass
	else:
		area.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
		area.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
		area.connect("input_event", Callable(self, "_on_area_input_event"))
	
	var name_label = $NameLabel
	name_label.text = card.card_name
	
	var damage_label = $DamageLabel
	damage_label.text = str(card.damage)

func _on_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("card_clicked", card, get_parent())

func _on_mouse_entered():
	if hoverable:
		scale = Vector2(scale[0] * 1.2, scale[1] * 1.2)
		z_index = 100

func _on_mouse_exited():
	if hoverable:
		scale = Vector2(scale[0] * (1/1.2), scale[1] * (1/1.2))
		z_index = 0
