extends Node

class_name Area

var areas: Dictionary = {
	"Forest": [
		{"name": "Goblin", "health": 50, "deck": []},
		{"name": "Orc", "health": 80, "deck": []}
	],
	"Desert": [
		{"name": "Scorpion", "health": 40, "deck": []},
		{"name": "Bandit", "health": 70, "deck": []}
	],
	"Mountain": [
		{"name": "Troll", "health": 100, "deck": []},
		{"name": "Dragon", "health": 150, "deck": []}
	]
}

func get_possible_enemies(area_name: String) -> Array:
	var possible_enemies = []
	if area_name in areas:
		for enemy_data in areas[area_name]:
			var enemy = Enemy.new()
			enemy.initialize(enemy_data["name"], enemy_data["health"], _create_enemy_deck())
			possible_enemies.append(enemy)
	return possible_enemies

func _create_enemy_deck() -> Array:
	var deck = []
	for i in range(7):
		var new_card = card.new("Card " + str(i + 1), "Effect", "Clause", "Type", "Sprite", 1)
		deck.append(new_card)
	return deck
