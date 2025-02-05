extends Node2D

class_name Planning

var player: Player
var enemy: Enemy
var selected_card_index: int = -1
var selected_cards: Array = []

var deck_rects: Array = []
var selected_rects: Array = []


func _ready():
	#player = get_parent().get_parent().get_node("Player")
	# print("Planning phase ready")
	if not player:
		player = get_parent().get_parent().get_node("Player")
		#player._create_test_deck()
		player.active_deck = player.player_deck.duplicate()
	#display_deck()
	_create_draw_button()

	# Initialize enemy if not already initialized
	if not enemy:
		var enemGen = enemyGeneration.new()
		var possible_enemies = enemGen.get_possible_enemies("Forest")
		enemy = possible_enemies[randi() % possible_enemies.size()]

	# # Print out the enemy details
	# print("Enemy initialized in planning phase")
	# print("Enemy name: ", enemy.enemy_name)
	# print("Enemy health: ", enemy.enemy_health)

	# print("Enemy deck: ")
	# for card in enemy.enemy_deck:
	# 	print(card.card_name)

	# print("Enemy active deck: ")
	# for card in enemy.active_deck:
	# 	print(card.card_name)

	# print("Enemy hand: ")
	# for card in enemy.enemy_hand:
	# 	print(card.card_name)


func draw_hand():
	player.player_hand.clear()
	for card in selected_cards:
		player.player_hand.append(card)
	selected_cards.clear()
	#display_deck()
	display_selected_queue() #this shouldn't be needed but it is (?) 
	transition_to_attack_phase()

func select_card(card_index: int):
	if player.active_deck.size() > card_index and selected_cards.size() < 7:
		var selected_card = player.active_deck[card_index]
		selected_cards.append(selected_card)
		player.active_deck.remove_at(card_index)
		print("Selected card: ", selected_card.card_name)
	elif selected_cards.size() >= 7:
		print("Hand is full")
	display_deck()
	display_selected_queue()

func deselect_card(card_index: int):
	var deselected_card = selected_cards[card_index]
	player.active_deck.append(deselected_card)
	selected_cards.remove_at(card_index)
	#print("Selected card: ", selected_card.card_name)
	display_deck()
	display_selected_queue()
	
func display_deck():
	print("displaying deck")
	deck_rects.clear()
	for child in get_children():
		if child is CardDisplay:
			child.queue_free()
	for i in range(player.active_deck.size()):
		var card_display = CardDisplay.new(player.active_deck[i].card_name, player.active_deck[i].card_damage)
		card_display.position = Vector2(10, (i * 35) + 20)
		add_child(card_display)
		deck_rects.append(Rect2(card_display.position, Vector2(200, 30)))

func display_selected_queue():
	var selected_queue = get_node("SelectedQueue")
	print("seleected queue position", selected_queue.position)
	selected_rects.clear()
	for child in selected_queue.get_children():
		child.queue_free()
	for i in range(selected_cards.size()):
		var card_display = CardDisplay.new(selected_cards[i].card_name, selected_cards[i].card_damage)
		card_display.position = Vector2(10, (i * 35) + 20)
		var hitbox_position = Vector2(card_display.position[0] + selected_queue.position[0], 
									  card_display.position[1] + selected_queue.position[1])
		selected_rects.append(Rect2(hitbox_position, Vector2(200, 30)))
		selected_queue.add_child(card_display)


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for i in range(deck_rects.size()):
			if deck_rects[i].has_point(event.position):
				select_card(i)
				print("Clicked a card in the Deck")

				break
		for i in range(selected_rects.size()):
			if selected_rects[i].has_point(event.position):
				deselect_card(i)
				#print("Clicked a Selected Card")
				break

func _create_draw_button():
	var button = Button.new()
	button.text = "Draw Hand"
	button.size = Vector2(100, 30)
	button.position = Vector2(10, get_viewport().size.y - 40)
	add_child(button)
	button.connect("pressed", Callable(self, "_on_draw_button_pressed"))

func _on_draw_button_pressed():
	draw_hand()

func transition_to_attack_phase():
	var attack_scene = get_parent().get_node("Attack_Phase")
	attack_scene._ready()
	attack_scene.player = self.player
	get_node("SelectedQueue").visible = false
	self.visible = false
	deck_rects.clear()
	attack_scene.visible = true
	attack_scene.transition_to_attack_phase()
