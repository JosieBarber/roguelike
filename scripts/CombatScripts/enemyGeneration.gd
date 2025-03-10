extends Node

class_name enemyGeneration

var areas: Dictionary = {
	"Forest": [
		{"name": "Goblin", "health": 25, "deck": [
			BapCard.new(),
			BlankCard.new("Card 2", "Effect", "Clause", "Type", "Sprite", 4, 10, []),
			BlankCard.new("Card 3", "Effect", "Clause", "Type", "Sprite", 1, 10, []),
			BlankCard.new("Card 4", "Effect", "Clause", "Type", "Sprite", 1, 10, []),
			BlankCard.new("Card 5", "Effect", "Clause", "Type", "Sprite", 1, 10, []),
			BlankCard.new("Card 6", "Effect", "Clause", "Type", "Sprite", 1, 10, []),
			BlankCard.new("Card 7", "Effect", "Clause", "Type", "Sprite", 1, 10, []),
			BlankCard.new("Card 8", "Effect", "Clause", "Type", "Sprite", 1, 10, [])
		]},
		{"name": "Orc", "health": 25, "deck": [
			BlankCard.new("Card 9", "Effect", "Clause", "Type", "Sprite", 1, 10, []),
			BlankCard.new("Card 10", "Effect", "Clause", "Type", "Sprite", 2, 10, []),
			BlankCard.new("Card 11", "Effect", "Clause", "Type", "Sprite", 1, 10, []),
			BlankCard.new("Card 12", "Effect", "Clause", "Type", "Sprite", 1, 10, []),
			BlankCard.new("Card 13", "Effect", "Clause", "Type", "Sprite", 1, 10, []),
			BlankCard.new("Card 14", "Effect", "Clause", "Type", "Sprite", 1, 10, []),
			BlankCard.new("Card 15", "Effect", "Clause", "Type", "Sprite", 1, 10, []),
			BlankCard.new("Card 16", "Effect", "Clause", "Type", "Sprite", 1, 10, [])
		]}
	],
}

func get_possible_enemies(area_name: String) -> Array:
	var possible_enemies = []
	if area_name in areas:
		for enemy_data in areas[area_name]:
			var enemy = Enemy.new()
			enemy.initialize(enemy_data["name"], enemy_data["health"], enemy_data["deck"])
			enemy.prepare_deck()
			possible_enemies.append(enemy)
	return possible_enemies
