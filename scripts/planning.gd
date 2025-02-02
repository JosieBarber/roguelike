extends Node2D

class_name Planning

var player: Player
var selected_card_index: int = -1
var card_rects: Array = []
var selected_cards: Array = []

func _ready():
	player = get_parent().get_node("Player")
	player.initialize("JosiePosie", 50)
	_create_test_deck()
	player.active_deck = player.player_deck.duplicate()
	display_deck()
	_create_draw_button()

func _create_test_deck():
	#Test function to create a deck of 15 cards
	for i in range(15):
		var new_card = card.new("Card " + str(i + 1), "Effect", "Clause", "Type", "Sprite", i + 1)
		player.player_deck.append(new_card)

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

func display_deck():
	card_rects.clear()
	for child in get_children():
		if child is CardDisplay:
			child.queue_free()
	for i in range(player.active_deck.size()):
		var card_display = CardDisplay.new(player.active_deck[i].card_name, player.active_deck[i].card_damage)
		card_display.position = Vector2(10, (i * 35) + 20)
		add_child(card_display)
		card_rects.append(Rect2(card_display.position, Vector2(200, 30)))

func display_selected_queue():
	var selected_queue = get_node("/root/Planning_Phase/SelectedQueue")
	for child in selected_queue.get_children():
		child.queue_free()
	for i in range(selected_cards.size()):
		var card_display = CardDisplay.new(selected_cards[i].card_name, selected_cards[i].card_damage)
		card_display.position = Vector2(10, (i * 35) + 20)
		selected_queue.add_child(card_display)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for i in range(card_rects.size()):
			if card_rects[i].has_point(event.position):
				select_card(i)
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
	var enemGen = enemyGeneration.new()
	var possible_enemies = enemGen.get_possible_enemies("Forest")
	var random_enemy = possible_enemies[randi() % possible_enemies.size()]
	var attack_scene = preload("res://scenes/Attack_Phase.tscn").instantiate()
	attack_scene.set("player", player)
	attack_scene.set("enemy", random_enemy)
	get_tree().root.add_child(attack_scene)
	queue_free()
