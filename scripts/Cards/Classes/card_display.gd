extends Node2D

class_name CardDisplay

signal card_clicked(card_name, card_damage, card_items)

var card_name: String
var card_damage: int
var card_items: Array

func _init(card_name_param: String, card_damage_param: int, card_items_param: Array):
	card_name = card_name_param
	card_damage = card_damage_param
	card_items = card_items_param

func _ready():
	var area = $Area2D
	print(area)

	area.connect("input_event", Callable(self, "_on_area_input_event"))

func _on_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Card clicked")
		emit_signal("card_clicked", card_name, card_damage, card_items)
