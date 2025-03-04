extends Node2D

class_name Attack

@export var player: Player
@export var enemy: Enemy
var combat: Combat
var ready_button = Node2D
var planning_scene: PackedScene

func _ready():
	

	player = get_parent().get_parent().get_node("Player")
	enemy = get_parent().get_node("Enemy")
	combat = get_parent()
	#_create_plan_button()


func transition_to_attack_phase():
	ready_button = get_parent().get_node("ReadyButton")
	ready_button.connect("ready_button_clicked", Callable(self, "_on_ready_button_clicked"))
	
	display_player_hand()
	display_enemy_hand()

	print("")
	print("Starting enemy health is: ", enemy.health)
	print("Starting player health is: ", player.health)

	pass
	
func _create_plan_button():
	var button = Button.new()
	button.text = "Draw Hand"
	button.size = Vector2(100, 30)
	button.position = Vector2(10, get_viewport().size.y - 40)
	add_child(button)
	button.connect("pressed", Callable(self, "_on_plan_button_pressed"))

func _on_plan_button_pressed():
	transition_to_planning_phase()

func _on_ready_button_clicked():
	if self.visible:
		next_turn()

func transition_to_planning_phase():
	ready_button.disconnect("ready_button_clicked", Callable(self, "transition_to_planning_phase"))
	self.visible = false
	
	var planning_scene = get_parent().get_node("Planning_Phase")
	planning_scene.visible = true
	planning_scene.refill_active_deck()
	planning_scene.display_deck()
	planning_scene.display_prepared_hand()

func calculate_damage(card, target):
	# This is where we will do funkies with items
	for item in card.items:
		if item is MultiplierCardItem:
			item.modify_damage(card)
	var damage = card.damage
	print(target.name, " was hit with ", card.card_name, ", and took ", damage, " damage.")
	return damage

func apply_damage(damage, target, damage_type):
	if damage_type == "Type":
		target.health -= damage
	elif damage_type == "magical":
		target.health -= damage
	elif damage_type == "Physical":
		target.health -= damage
	# We should do this differently but thats fine

	if target == player:
		if target.health <= 0:
			pass
			#print(target.player_name, " has been defeated!")
	if target == enemy:
		if target.health <= 0:
			pass
			#print(target.enemy_name, " has been defeated!")

func calculate_dot(dot_effect, target):
	var dot_damage = dot_effect.damage
	# Add any additional effects or modifiers here
	apply_damage(dot_damage, target, dot_effect.card_type)

func next_turn():
	print("")
	if player.hand.size() != 0:
		var player_card = player.hand[0]
		var player_damage = calculate_damage(player_card, enemy)
		apply_damage(player_damage, enemy, player_card.card_type)
		player.hand.remove_at(0)

		var player_played_node = get_node("PlayerPlayed")
		var player_card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		player_card_display.card = player_card
		player_card_display.scale = Vector2(1.3, 1.3)
		player_card_display.position = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		player_card_display.rotation_degrees = randf_range(-10, 10)
		player_played_node.add_child(player_card_display)

	if enemy.hand.size() != 0:
		var enemy_card = enemy.hand[0]
		var enemy_damage = calculate_damage(enemy_card, player)
		apply_damage(enemy_damage, player, enemy_card.card_type)
		enemy.hand.remove_at(0)
		
		var enemy_played_node = get_node("EnemyPlayed")
		var enemy_card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		enemy_card_display.card = enemy_card
		enemy_card_display.scale = Vector2(1.3, 1.3)
		enemy_card_display.position = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		enemy_card_display.rotation_degrees = randf_range(-10, 10)
		enemy_played_node.add_child(enemy_card_display)

	## Apply any DOT effects
	for dot_effect in player.active_dot_effects:
		calculate_dot(dot_effect, enemy)
	for dot_effect in enemy.active_dot_effects:
		calculate_dot(dot_effect, player)
		
		
	print("Enemy Health is now: ", enemy.health)
	print("Player Health is now: ", player.health)

	display_player_hand()
	display_enemy_hand()

	if player.health <= 0:
		print(player.player_name, " has been defeated!")
		combat._on_combat_end()
		return "end"
	if enemy.health <= 0:
		print(enemy.enemy_name, " has been defeated!")
		combat._on_combat_end()
		return "end"
	if player.hand.size() == 0 and enemy.hand.size() == 0:
		print("Both parties have no cards left in their hand!")
		ready_button.disconnect("ready_button_clicked", Callable(self, "_on_ready_button_clicked"))
		ready_button.connect("ready_button_clicked", Callable(self, "transition_to_planning_phase"))
		return "end"


func display_player_hand():
	var player_hand_object = get_node("PlayerHand")
	for child in player_hand_object.get_children():
		child.queue_free()
	for i in range(player.hand.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card = player.hand[i]
		card_display.scale = Vector2(1.3, 1.3)
		card_display.position = Vector2(0, int(i * 5))
		card_display.add_to_group("CardDisplays")
		player_hand_object.add_child(card_display)

func display_enemy_hand():
	var enemy_hand_object = get_node("EnemyHand")
	for child in enemy_hand_object.get_children():
		child.queue_free()
	for i in range(enemy.hand.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card = enemy.hand[i]
		card_display.scale = Vector2(1.3, 1.3)
		card_display.position = Vector2(0, int(i * 5))
		card_display.add_to_group("CardDisplays")
		enemy_hand_object.add_child(card_display)
