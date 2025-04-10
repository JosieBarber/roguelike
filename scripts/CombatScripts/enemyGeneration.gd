extends Node

class_name enemyGeneration

var areas: Dictionary = {
	"Forest": [
		"res://scripts/CombatScripts/Enemies/self_heal.gd",
	],
}

func get_possible_enemies(area_name: String) -> Array:
	var possible_enemies = []
	if area_name in areas:
		for enemy_path in areas[area_name]:
			var enemy_script = load(enemy_path)
			if enemy_script:
				possible_enemies.append(enemy_script)
	return possible_enemies
