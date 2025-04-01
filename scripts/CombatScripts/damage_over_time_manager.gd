extends Node

class_name DamageOverTimeManager

var active_effects: Array = []

func add_effect(target, damage: int, duration: int, interval: int) -> void:
	active_effects.append({
		"target": target,
		"damage": damage,
		"duration": duration,
		"interval": interval,
		"turns_elapsed": 0,
		"turns_since_last_damage": 0
	})

func advance_turn() -> void:
	for effect in active_effects:
		effect["turns_elapsed"] += 1
		effect["turns_since_last_damage"] += 1
		
		print(effect)
		
		if effect["turns_since_last_damage"] >= effect["interval"]:
			effect["turns_since_last_damage"] = 0
			apply_damage(effect["target"], effect["damage"])
		
		if effect["turns_elapsed"] >= effect["duration"]:
			active_effects.erase(effect)

func apply_damage(target, damage: int) -> void:
	target.set_health(target.max_health, target.health - damage)
	print(target.name, " took ", damage, " damage from a damage-over-time effect.")
