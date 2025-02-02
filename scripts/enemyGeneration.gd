extends Node

class_name enemyGeneration

var areas: Dictionary = {
	"Forest": [
		{"name": "Goblin", "health": 50, "deck": [
			card.new("Card 1", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 2", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 3", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 4", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 5", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 6", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 7", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 8", "Effect", "Clause", "Type", "Sprite", 1)
		]},
		{"name": "Orc", "health": 80, "deck": [
			card.new("Card 9", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 10", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 11", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 12", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 13", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 14", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 15", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 16", "Effect", "Clause", "Type", "Sprite", 1)
		]}
	],
	"Desert": [
		{"name": "Scorpion", "health": 40, "deck": [
			card.new("Card 17", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 18", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 19", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 20", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 21", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 22", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 23", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 24", "Effect", "Clause", "Type", "Sprite", 1)
		]},
		{"name": "Bandit", "health": 70, "deck": [
			card.new("Card 25", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 26", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 27", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 28", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 29", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 30", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 31", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 32", "Effect", "Clause", "Type", "Sprite", 1)
		]}
	],
	"Mountain": [
		{"name": "Troll", "health": 100, "deck": [
			card.new("Card 33", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 34", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 35", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 36", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 37", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 38", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 39", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 40", "Effect", "Clause", "Type", "Sprite", 1)
		]},
		{"name": "Dragon", "health": 150, "deck": [
			card.new("Card 41", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 42", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 43", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 44", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 45", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 46", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 47", "Effect", "Clause", "Type", "Sprite", 1),
			card.new("Card 48", "Effect", "Clause", "Type", "Sprite", 1)
		]}
	]
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

# func _create_enemy_deck() -> Array:
# 	var deck = []
# 	for i in range(7):
# 		var new_card = card.new("Card " + str(i + 1), "Effect", "Clause", "Type", "Sprite", 1)
# 		deck.append(new_card)
# 	return deck
