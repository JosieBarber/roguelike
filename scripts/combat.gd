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
	$Button.visible = false
	_initialize_player()
	_initialize_enemy()
	transition_to_planning_phase()

func _initialize_player():
	player = get_parent().get_node("Player")
	print("Player name at combat: ", player.player_name)
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
	var planning_scene = get_node("Planning_Phase")
	planning_scene.set("player", player)
	player.copy_deck()
	planning_scene.get_node("Planning").display_deck()
	planning_scene.visible = true
	# self.self_modulate = Color(1, 1, 1, 0) # Zero opacity
