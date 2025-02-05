extends Control

class_name Combat


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

func _initialize_enemy():
	var enemGen = enemyGeneration.new()
	var possible_enemies = enemGen.get_possible_enemies("Forest")
	enemy = possible_enemies[randi() % possible_enemies.size()]
	enemy.prepare_deck()

func transition_to_planning_phase():
	print("Player active deck size: ", player.active_deck.size())
	print("Player full deck size: ", player.player_deck.size())

	print("Transitioning to planning phase")
	var planning_scene = get_node("Planning_Phase")
	planning_scene.set("player", player)
	player.copy_deck()
	planning_scene.visible = true
	planning_scene.display_deck()
	print(player.active_deck.size())
