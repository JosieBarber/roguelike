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

var effect_methods: Array

func apply_effect(target, source) -> void:

	var adjusted_damage = calculate_damage(target, source, damage,items)
	target.set_health(target.max_health, target.health - adjusted_damage)
	print(target.name, " was hit with ", card_name, ", and took ", adjusted_damage, " damage.")

	
func calculate_damage(target, source, damage: int, items: Array) -> int:
	print("Damage before modification: ", damage)
	for item in items:
		if item.has_method("_modify_damage"):
			item._modify_damage(damage)
	for affliction in source.afflictions:
		if affliction.has_method("_modify_outgoing_damage"):
			affliction._modify_outgoing_damage(damage)
	for affliction in target.afflictions:
		if affliction.has_method("_modify_incoming_damage"):
			affliction._modify_outgoing_damage(damage)
	print("Damage after modifications: ", damage)
	return damage
	
