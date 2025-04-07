extends Node

class_name enemyGeneration

var areas: Dictionary = {
	"Forest": [
		{"name": "Goblin", "health": 25, "deck": _create_test_deck(7)},
		{"name": "Orc", "health": 25, "deck": _create_test_deck(5)}
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
	
func _create_test_deck(deck_size) -> Array:
	#deck.clear()
	var test_deck = []
	var test_cards = Cards.test_cards.duplicate()
	
	
	print("Loaded test cards: ", test_cards)

	while test_deck.size() < deck_size and test_cards.size() > 0:
		var random_index = randi() % test_cards.size()
		var card_instance = test_cards[random_index].new()
		test_deck.append(card_instance)
		test_cards.remove_at(random_index)
	return test_deck
