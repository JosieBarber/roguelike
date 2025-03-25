extends Node2D

class_name Card

var card_name: String
var effect: String
var clause: String
var card_type: String
var sprite: String
var damage: int
var value: int
var items: Array

func apply_effect(target, source) -> void:
	# Default behavior: deal damage
	target.set_health(target.max_health, target.health - damage)
	print(target.name, " was hit with ", card_name, ", and took ", damage, " damage.")
