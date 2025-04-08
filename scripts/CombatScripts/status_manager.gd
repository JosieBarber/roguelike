extends Node

var active_effects: Array = []

func add_damage_effect(target, damage: int, duration: int, interval: int, source = null) -> void:
	active_effects.append({
		"target": target,
		"damage": damage,
		"duration": duration,
		"interval": interval,
		"turns_elapsed": 0,
		"turns_since_last_damage": 0,
		"source": source,
		"DOT": true
	})

func add_effect(effect):
	active_effects.append(effect)

func advance_turn() -> void:
	for effect in active_effects:
		if effect.has("DOT"):
			effect["turns_elapsed"] += 1
			effect["turns_since_last_damage"] += 1

			print(effect)

			if effect["turns_since_last_damage"] >= effect["interval"]:
				effect["turns_since_last_damage"] = 0
				apply_damage(effect["target"], effect["damage"], effect["source"])

			if effect["turns_elapsed"] >= effect["duration"]:
				active_effects.erase(effect)

func end_round() -> void:
	for effect in active_effects:
		if effect.has("source") and effect["source"]:
			effect["source"].temporary_effects = effect["source"].temporary_effects.filter(
				func(e): return not e.has("round_end_removal") or not e["round_end_removal"]
			)
		if effect.has("target") and effect["target"]:
			effect["target"].temporary_effects = effect["target"].temporary_effects.filter(
				func(e): return not e.has("round_end_removal") or not e["round_end_removal"]
			)
	print("Round ended. Temporary effects with round_end_removal have been cleared.")

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
	
	# Apply target temporary effects
	if target:
		for effect in target.temporary_effects:
			if effect.has("remaining_instances") and effect["remaining_instances"] > 0:
				if effect.has("damage_prevention") and effect["damage_prevention"]:
					effect["remaining_instances"] -= 1
					print(target.name, " prevented damage. Remaining instances: ", effect["remaining_instances"])
					return
				if effect.has("backswing") and effect["backswing"]:
					effect["remaining_instances"] -= 1
					effect["backswing"].call(adjusted_damage)
				

		# Remove expired effects
		target.temporary_effects = target.temporary_effects.filter(
			func(e): return e.has("remaining_instances") and e["remaining_instances"] > 0
		)
	
	target.set_health(target.max_health, target.health - adjusted_damage)
	print(target.name, " took ", adjusted_damage, " damage from a damage-over-time effect.")
	
func clear_active_effects():
	active_effects.clear()
