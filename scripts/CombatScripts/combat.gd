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

func _on_enemy_defeat():
	var navigation_scene = get_parent().get_node("Navigation")
	var npc_ui = navigation_scene.get_parent().get_node("Ui").get_node("EnemyUi")

	navigation_scene.visible = true
	npc_ui.visible = false
	
	queue_free()
	
func _on_player_defeat():
	var main_scene = get_parent()
	
	# Hide all nodes except Player UI
	for child in main_scene.get_children():
		if child.name != "Ui":
			child.visible = false
		else:
			for subchild in child.get_children():
				if subchild.name != "PlayerUi":
					subchild.visible = false
				else:
					subchild.get_node("MetalPanel").get_node("Hearts").visible = false
	var death_scene = preload("res://scenes/Screens/Death_Screen.tscn").instantiate()
	main_scene.add_child(death_scene)


func _initialize_player():
	player = get_parent().get_node("Player")

func _initialize_enemy():
	enemy = get_node("Enemy")
	enemy.prepare_enemy()
	enemy.prepare_deck()

func transition_to_planning_phase():
	print("Player active deck size: ", player.active_deck.size())
	print("Player full deck size: ", player.deck.size())

	print("Transitioning to planning phase")
	var planning_scene = get_node("Planning_Phase")
	planning_scene.set("player", player)
	player.copy_deck()
	planning_scene.visible = true
	planning_scene.display_deck()
	print(player.active_deck.size())
