extends Node2D

class_name CardDisplay

var card_name: String
var card_damage: int

func _init(card_name_param: String, card_damage_param: int):
	card_name = card_name_param
	card_damage = card_damage_param

func _ready():
	var rect = ColorRect.new()
	rect.color = Color(0.8, 0.8, 0.8)
	rect.size = Vector2(200, 30)
	add_child(rect)

	var label = Label.new()
	label.text = card_name + " - Damage: " + str(card_damage)
	label.uppercase = true
	label.position = Vector2(10, 5)
	rect.add_child(label)
