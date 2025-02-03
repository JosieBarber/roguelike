extends Control

class_name Combat

# Ensure the Card class is available
const Card = preload("res://scripts/card.gd")

var player: Player
var enemy: Enemy

func _ready():
	var button = $Button
	button.connect("pressed", Callable(self, "_on_start_combat_pressed"))

func _on_start_combat_pressed():
	_initialize_player()
	_initialize_enemy()
	transition_to_planning_phase()

func _initialize_player():
	player = Player.new()
	player.initialize("JosiePosie", 50)
	_create_test_deck(player)

func _initialize_enemy():
	var enemGen = enemyGeneration.new()
	var possible_enemies = enemGen.get_possible_enemies("Forest")
	enemy = possible_enemies[randi() % possible_enemies.size()]
	enemy.prepare_deck()

func _create_test_deck(player: Player):
	# Test function to create a deck of 15 cards
	for i in range(15):
		var new_card = Card.new("Card " + str(i + 1), "Effect", "Clause", "Type", "Sprite", i + 1)
		player.player_deck.append(new_card)

func transition_to_planning_phase():
	print("Transitioning to planning phase")
	var planning_scene = preload("res://scenes/Planning_Phase.tscn").instantiate()
	planning_scene.set("player", player)
	planning_scene.set("enemy", enemy)
	get_tree().root.add_child(planning_scene)
	queue_free()
