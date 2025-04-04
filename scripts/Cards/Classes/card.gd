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

#@onready var dot_manager = get_tree().get_root().get_node("Path/To/DamageOverTimeManager")


func apply_effect(target, source) -> void:
	var adjusted_damage = calculate_damage(target, source, damage, items)
	target.set_health(target.max_health, target.health - adjusted_damage)
	print(target.name, " was hit with ", card_name, ", and took ", adjusted_damage, " damage.")

func apply_temporary_effect(temp_effect: Dictionary) -> void:
	temporary_effects.append(temp_effect)

func calculate_damage(target, source, card_damage: int, card_items: Array) -> int:
	# print("Damage before modification: ", damage)
	var adjusted_damage = card_damage
	
	# Apply temporary effects
	for temporary_effect in temporary_effects:
		if "_modify_damage" in temporary_effect:
			adjusted_damage = temporary_effect["_modify_damage"].call(adjusted_damage)
	
	# Apply item-based modifications
	for item in card_items:
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
	for temporary_effect in source.temporary_effects:
		if temporary_effect.has("remaining_instances") and temporary_effect["remaining_instances"] > 0:
			if temporary_effect.has("damage_bonus"):
				adjusted_damage += temporary_effect["damage_bonus"]
				temporary_effect["remaining_instances"] -= 1
			if temporary_effect.has("_modify_effect"):
				temporary_effect["remaining_instances"] -= 1
				temporary_effect["_modify_effect"].call(self, target, source)

	# Remove expired effects
	source.temporary_effects = source.temporary_effects.filter(
		func(e): return e.has("remaining_instances") and e["remaining_instances"] > 0
	)
	
	# Apply target temporary effects
	for temporary_effect in target.temporary_effects:
		if temporary_effect.has("remaining_instances") and temporary_effect["remaining_instances"] > 0:
			if temporary_effect.has("damage_prevention") and temporary_effect["damage_prevention"]:
				temporary_effect["remaining_instances"] -= 1
				print(target.name, " prevented damage. Remaining instances: ", temporary_effect["remaining_instances"])
				return 0  # Damage is fully prevented
			if temporary_effect.has("backswing") and temporary_effect["backswing"]:
				temporary_effect["remaining_instances"] -= 1
				temporary_effect["backswing"].call(adjusted_damage)
				
	# Remove expired effects
	target.temporary_effects = target.temporary_effects.filter(
		func(e): return e.has("remaining_instances") and e["remaining_instances"] > 0
	)
	
	if target.hand.size() >= 1:
		if target.hand[0].has_method("_apply_block"):
			adjusted_damage = target.hand[0]._apply_block(target, source, adjusted_damage, items)

	# print("Damage after modifications: ", adjusted_damage)
	temporary_effects.clear()
	return max(adjusted_damage, 0)
