extends Node2D

class_name CardDisplay

signal card_clicked(card, parent_node)

var card: Card

func _ready():
	var area = $Area2D
	if area == null:
		pass
	else:
		area.connect("input_event", Callable(self, "_on_area_input_event"))
	
	var name_label = $NameLabel
	name_label.text = card.card_name
	
	var damage_label = $DamageLabel
	damage_label.text = str(card.damage)

func _on_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("card_clicked", card, get_parent())
