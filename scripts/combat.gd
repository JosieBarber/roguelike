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

func _on_combat_end():
	# Transition back to the navigation scene
	var navigation_scene = get_parent().get_node("Navigation")
	var attack_scene = get_node("Attack_Phase")
	var planning_scene = get_node("Planning_Phase")
	navigation_scene.visible = true
	
	attack_scene.visible = false
	planning_scene.visible = false
	self.visible = false

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
