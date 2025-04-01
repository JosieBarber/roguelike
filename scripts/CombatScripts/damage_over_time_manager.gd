extends Node

class_name DamageOverTimeManager

var active_effects: Array = []

func add_effect(target, damage: int, duration: int, interval: int, source = null) -> void:
	active_effects.append({
		"target": target,
		"damage": damage,
		"duration": duration,
		"interval": interval,
		"turns_elapsed": 0,
		"turns_since_last_damage": 0,
		"source": source
	})

func advance_turn() -> void:
	for effect in active_effects:
		effect["turns_elapsed"] += 1
		effect["turns_since_last_damage"] += 1

		print(effect)

		if effect["turns_since_last_damage"] >= effect["interval"]:
			effect["turns_since_last_damage"] = 0
			apply_damage(effect["target"], effect["damage"], effect["source"])

		if effect["turns_elapsed"] >= effect["duration"]:
			active_effects.erase(effect)

func apply_damage(target, damage: int, source = null) -> void:
	var adjusted_damage = damage
	
	# Apply source temporary effects
	if source:
		for effect in source.temporary_effects:
			if effect.has("remaining_instances") and effect["remaining_instances"] > 0:
				if effect.has("damage_bonus"):
					adjusted_damage += effect["damage_bonus"]
					effect["remaining_instances"] -= 1

		# Remove expired effects
		source.temporary_effects = source.temporary_effects.filter(
			func(e): return e.has("remaining_instances") and e["remaining_instances"] > 0
		)
	
	target.set_health(target.max_health, target.health - adjusted_damage)
	print(target.name, " took ", adjusted_damage, " damage from a damage-over-time effect.")
