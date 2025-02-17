#Card.gd

extends Node

class_name Card

var card_name: String
var effect: String
var clause: String
var card_type: String
var sprite: String
var damage: int
var value: int
var items: Array

func _init(card_name_param: String, effect_param: String, clause_param: String, card_type_param: String, sprite_param: String, damage_param: int, value_param: int, items_param: Array):
	card_name = card_name_param
	effect = effect_param
	clause = clause_param
	card_type = card_type_param
	sprite = sprite_param
	damage = damage_param
	value = value_param
	items = items_param

func _ready():
	# Initialize the card when it is added to the scene
	pass
