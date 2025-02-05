extends Node2D

class_name Attack

@export var player: Player
@export var enemy: Enemy

var planning_scene: PackedScene

func _ready():
	if not player:
		player = get_parent().get_parent().get_node("Player")
		player._create_test_deck()
		player.active_deck = player.player_deck.duplicate()
	# display_deck()

	# Initialize enemy if not already initialized
	if not enemy:
		var enemGen = enemyGeneration.new()
		var possible_enemies = enemGen.get_possible_enemies("Forest")
		enemy = possible_enemies[randi() % possible_enemies.size()]




func transition_to_attack_phase():
	enemy.prepare_hand()
	
	 # Print out the enemy details	
	print("Enemy name: ", enemy.enemy_name)
	print("Enemy health: ", enemy.enemy_health)

	print("Enemy deck: ")
	for card in enemy.enemy_deck:
		print(card.card_name)

	print("Enemy active deck: ")
	for card in enemy.active_deck:
		print(card.card_name)

	print("Enemy hand: ")
	for card in enemy.enemy_hand:
		print(card.card_name)
	#pass

func transition_to_planning_phase():
	var planning_scene = get_node("Planning_Phase")
	planning_scene.set("player", player)
	planning_scene.set("enemy", enemy)
	planning_scene.visible = true
	self.visible = false
