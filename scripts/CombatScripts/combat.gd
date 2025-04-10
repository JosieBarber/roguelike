extends Control

class_name Combat

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var enemy: Node2D = get_node("Enemy")

@onready var ui_scene = get_tree().get_first_node_in_group("Ui")
@onready var location_panel = ui_scene.location_panel
@onready var enemy_ui = ui_scene.npc_panel
@onready var navigation_scene = get_tree().get_first_node_in_group("navigation")
@onready var planning_scene = get_node("Planning_Phase")
@onready var card_selection_scene = $CardSelectionPhase

@onready var enemy_node = $Enemy
var enemy_generation: enemyGeneration

func _ready() -> void:
	enemy_generation = enemyGeneration.new()
	var possible_enemies = []

	# Check if this is the final boss encounter
	if self.has_meta("is_final_boss") and self.get_meta("is_final_boss") == true:
		print("Final boss encounter detected")
		var finalBossScript = load("res://scripts/CombatScripts/Enemies/final_boss.gd")
		if finalBossScript:
			enemy_node.set_script(finalBossScript)
			enemy_node.call("_ready")
			enemy_node.set_health(enemy_node.max_health, enemy_node.health)
			return

	# Check if this is a boss encounter
	if self.has_meta("is_boss_encounter") and self.get_meta("is_boss_encounter") == true:
		print("Boss encounter detected")
		possible_enemies = enemy_generation.get_boss_enemies()
	else:
		print("Regular encounter detected")
		possible_enemies = enemy_generation.get_possible_enemies("Forest")

	if possible_enemies.size() > 0:
		var selected_enemy_script = possible_enemies[randi() % possible_enemies.size()]
		enemy_node.set_script(selected_enemy_script)
		enemy_node.call("_ready")
		enemy_node.set_health(enemy_node.max_health, enemy_node.health)

	Events._navigation_focus.emit(false, true)
	enemy.connect("enemy_health_changed", Callable(enemy_ui, "_on_enemy_health_changed"))
	_initialize_player()
	_initialize_enemy()
	transition_to_planning_phase()

func _on_enemy_defeat():
	enemy_ui.visible = false
	DOT.clear_active_effects()
	$Attack_Phase.queue_free()
	transition_to_card_selection_phase()

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
	#enemy.prepare_enemy()
	enemy.prepare_deck()
	enemy_ui._on_enemy_health_changed(enemy.max_health, enemy.health)

func transition_to_planning_phase():
	Events._navigation_focus.emit(false, true)
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

func transition_to_card_selection_phase():
	card_selection_scene.visible = true
	card_selection_scene.set_enemy_deck(enemy.deck)
	enemy_node.set_script(null)
