extends Node2D

class_name CardDisplay

signal card_clicked(card_name, card_damage, card_items, parent_node)

var card_name: String
var card_damage: int
var card_items: Array

# func _init(card_name_param: String, card_damage_param: int, card_items_param: Array):
# 	card_name = card_name_param
# 	card_damage = card_damage_param
# 	card_items = card_items_param

func _ready():
	var area = $Area2D
	if area == null:
		print("Area2D node not found")
	else:
		print(area)
		area.connect("input_event", Callable(self, "_on_area_input_event"))
	
	var name_label = $NameLabel
	name_label.text = card_name
	
	var damage_label = $DamageLabel
	damage_label.text = str(card_damage)

func _on_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Card clicked")
		emit_signal("card_clicked", card_name, card_damage, card_items, get_parent())
