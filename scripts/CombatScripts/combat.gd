extends Control

class_name Combat

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var enemy: Enemy = get_node("Enemy")

@onready var ui_scene = get_tree().get_first_node_in_group("Ui")
@onready var location_panel = ui_scene.location_panel
@onready var enemy_ui = ui_scene.npc_panel
@onready var navigation_scene = get_tree().get_first_node_in_group("navigation")
@onready var planning_scene = get_node("Planning_Phase")



func _ready() -> void:
	enemy.connect("enemy_health_changed", Callable(enemy_ui, "_on_enemy_health_changed"))
	_initialize_player()
	_initialize_enemy()
	transition_to_planning_phase()

func _on_enemy_defeat():
	#var navigation_scene = get_parent().get_node("Navigation")

	navigation_scene.visible = true
	enemy_ui.visible = false
	
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
	player.prepare_deck()

func _initialize_enemy():
	enemy.prepare_enemy()
	enemy.prepare_deck()

func transition_to_planning_phase():
	print("Player active deck size: ", player.active_deck.size())
	print("Player full deck size: ", player.deck.size())

	print("Transitioning to planning phase")
	planning_scene.set("player", player)
	player.copy_deck()
	planning_scene.visible = true
	location_panel.visible = false
	enemy_ui.visible = true
	planning_scene.display_deck()
	print(player.active_deck.size())
