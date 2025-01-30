extends Node2D

class_name Planning

var player: Player
var selected_card_index: int = -1
var card_rects: Array = []
var selected_indices: Array = []

func _ready():
	player = get_parent().get_node("Player")
	player.initialize("Player1", 100)
	_create_test_deck()
	display_deck()
	_create_draw_button()

func _create_test_deck():
	#Test function to create a deck of 15 cards
	for i in range(15):
		var new_card = card.new("Card " + str(i + 1), "Effect", "Clause", "Type", "Sprite", i + 1)
		player.player_deck.append(new_card)

func draw_hand():
	player.player_hand.clear()
	selected_indices.sort()
	selected_indices.reverse()
	for index in selected_indices:
		if index >= 0 and index < player.player_deck.size() and player.player_hand.size() < 7:
			player.player_hand.append(player.player_deck[index])
			player.player_deck.remove_at(index)
	selected_indices.clear()
	display_deck()
	display_selected_queue()

func select_card(card_index: int):
	if card_index not in selected_indices and selected_indices.size() < 7:
		selected_indices.append(card_index)
		print("Selected card index: ", card_index)
	display_selected_queue()

func display_deck():
	card_rects.clear()
	for child in get_children():
		if child is CardDisplay:
			child.queue_free()
	for i in range(player.player_deck.size()):
		if i not in selected_indices:
			var card_display = CardDisplay.new(player.player_deck[i].card_name, player.player_deck[i].card_damage)
			card_display.position = Vector2(10, (i * 35) + 20)
			add_child(card_display)
			card_rects.append(Rect2(card_display.position, Vector2(200, 30)))

func display_selected_queue():
	var selected_queue = get_node("/root/Planning_Phase/SelectedQueue")
	for child in selected_queue.get_children():
		child.queue_free()
	for i in range(selected_indices.size()):
		var card_display = CardDisplay.new(player.player_deck[selected_indices[i]].card_name, player.player_deck[selected_indices[i]].card_damage)
		card_display.position = Vector2(10, (i * 35) + 20)
		selected_queue.add_child(card_display)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for i in range(card_rects.size()):
			if card_rects[i].has_point(event.position):
				print("card " + str(i + 1) + " clicked")
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
