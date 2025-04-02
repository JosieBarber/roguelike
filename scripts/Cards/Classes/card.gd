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

var temporary_effects: Array

var effect_methods: Array

@onready var dot_manager = get_tree().get_root().get_node("Path/To/DamageOverTimeManager")


func apply_effect(target, source) -> void:
	var adjusted_damage = calculate_damage(target, source, damage, items)
	target.set_health(target.max_health, target.health - adjusted_damage)
	print(target.name, " was hit with ", card_name, ", and took ", adjusted_damage, " damage.")

func apply_temporary_effect(effect: Dictionary) -> void:
	temporary_effects.append(effect)

func calculate_damage(target, source, damage: int, items: Array) -> int:
	# print("Damage before modification: ", damage)
	var adjusted_damage = damage
	
	# Apply temporary effects
	for effect in temporary_effects:
		if "_modify_damage" in effect:
			adjusted_damage = effect["_modify_damage"].call(adjusted_damage)
	
	# Apply item-based modifications
	for item in items:
		if item.has_method("_modify_damage"):
			adjusted_damage = item._modify_damage(adjusted_damage)

	# Apply source affliction modifications
	for affliction in source.afflictions:
		if affliction.has_method("_modify_outgoing_damage"):
			adjusted_damage = affliction._modify_outgoing_damage(adjusted_damage)

	# Apply target affliction modifications
	for affliction in target.afflictions:
		if affliction.has_method("_modify_incoming_damage"):
			adjusted_damage = affliction._modify_incoming_damage(adjusted_damage)

	# Apply source temporary effects
	for effect in source.temporary_effects:
		if effect.has("remaining_instances") and effect["remaining_instances"] > 0:
			if effect.has("damage_bonus"):
				adjusted_damage += effect["damage_bonus"]
				effect["remaining_instances"] -= 1

	# Remove expired effects
	source.temporary_effects = source.temporary_effects.filter(
		func(e): return e.has("remaining_instances") and e["remaining_instances"] > 0
	)
	
	if target.hand[0].has_method("_apply_block"):
		adjusted_damage = target.hand[0]._apply_block(target, source, adjusted_damage, items)

	# print("Damage after modifications: ", adjusted_damage)
	temporary_effects.clear()
	return max(adjusted_damage, 0)
