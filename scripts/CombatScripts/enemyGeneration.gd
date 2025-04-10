extends Node

class_name enemyGeneration

var areas: Dictionary = {
	"Forest": [
		"res://scripts/CombatScripts/Enemies/self_heal.gd",
		"res://scripts/CombatScripts/Enemies/card_play.gd",
		"res://scripts/CombatScripts/Enemies/hubris.gd",
		"res://scripts/CombatScripts/Enemies/damage.gd",
		"res://scripts/CombatScripts/Enemies/blocking.gd",
		"res://scripts/CombatScripts/Enemies/upgrade.gd",
		"res://scripts/CombatScripts/Enemies/heart_attack.gd"
	],
	"Boss": [
		"res://scripts/CombatScripts/Bosses/bonk.gd",
		"res://scripts/CombatScripts/Bosses/dot_goober.gd"
	]
}

func get_possible_enemies(area_name: String) -> Array:
	var possible_enemies = []
	if area_name in areas:
		for enemy_path in areas[area_name]:
			var enemy_script = load(enemy_path)
			if enemy_script:
				possible_enemies.append(enemy_script)
	return possible_enemies

func get_boss_enemies() -> Array:
	var boss_enemies = []
	if "Boss" in areas:
		for enemy_path in areas["Boss"]:
			var enemy_script = load(enemy_path)
			if enemy_script:
				boss_enemies.append(enemy_script)
	return boss_enemies
