extends Node2D

class_name Attack

@export var player: Player
@export var enemy: Enemy
var combat: Combat

var planning_scene: PackedScene

func _ready():
	player = get_parent().get_parent().get_node("Player")
	enemy = get_parent().get_node("Enemy")
	combat = get_parent()
	_create_plan_button()
	

func transition_to_attack_phase():

	print("Enemy hand: ")
	for card in enemy.hand:
		print(card.card_name)
		
	print("Player hand: ")
	for card in player.hand:
		print(card.card_name)
	print("-------------------------------------")
	print("Enemy Health: ", enemy.health)
	print("Player Health: ", player.health)
		
	for i in range(7):
		if next_turn() == "end":
			break
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

func calculate_damage(card, target):
	var damage = card.damage
	# This is where we will do funkies with items
	return damage

func apply_damage(damage, target, damage_type):
	if damage_type == "Type":
		target.health -= damage
	elif damage_type == "magical":
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
	if player.hand.size() != 0:
		var player_card = player.hand[0]
		print(player_card.items[0].item_name)
		var player_damage = calculate_damage(player_card, enemy)
		apply_damage(player_damage, enemy, player_card.card_type)
		player.hand.remove_at(0)
	if enemy.hand.size() != 0:
		var enemy_card = enemy.hand[0]
		#print(enemy_card.items[0].item_name)
		var enemy_damage = calculate_damage(enemy_card, player)
		apply_damage(enemy_damage, player, enemy_card.card_type)
		enemy.hand.remove_at(0)
		
	## Apply any DOT effects
	for dot_effect in player.active_dot_effects:
		calculate_dot(dot_effect, enemy)
	for dot_effect in enemy.active_dot_effects:
		calculate_dot(dot_effect, player)
		
		
	print("-------------------------------------")
	print("Enemy Health: ", enemy.health)
	print("Player Health: ", player.health)
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
		#combat._on_combat_end()
		return "end"
	



	#print("Next turn executed.")
