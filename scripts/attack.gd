extends Node2D

class_name Attack

@export var player: Player
@export var enemy: Enemy

var planning_scene: PackedScene

func _ready():
	player = get_parent().get_parent().get_node("Player")
	enemy = get_parent().get_node("Enemy")
	_create_plan_button()
	
	

	#if not player:
		#player._create_test_deck()
		#player.active_deck = player.player_deck.duplicate()
	## display_deck()
#
	## Initialize enemy if not already initialized
	#if not enemy:
		#var enemGen = enemyGeneration.new()
		#var possible_enemies = enemGen.get_possible_enemies("Forest")
		#enemy = possible_enemies[randi() % possible_enemies.size()]




func transition_to_attack_phase():
	print("Enemy at attack phase: ", enemy.enemy_name)
	
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
	
func _create_plan_button():
	var button = Button.new()
	button.text = "Draw Hand"
	button.size = Vector2(100, 30)
	button.position = Vector2(10, get_viewport().size.y - 40)
	add_child(button)
	button.connect("pressed", Callable(self, "_on_plan_button_pressed"))

func _on_plan_button_pressed():
	transition_to_planning_phase()

func transition_to_planning_phase():
	self.visible = false
	
	var planning_scene = get_parent().get_node("Planning_Phase")
	planning_scene.visible = true
	planning_scene.display_deck()
	planning_scene.display_prepared_hand()
