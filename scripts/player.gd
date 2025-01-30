#player.gd

extends Node2D

class_name Player

var player_name: String
var player_status: String
var player_health: int
var player_hand: Array
var player_deck: Array
var player_discard: Array

var selected_card_index: int = -1
var card_rects: Array = []

func initialize(player_name_param: String, health: int):
	player_name = player_name_param
	player_health = health
	player_hand = []
	player_deck = []
	player_discard = []

func _ready():
	_create_test_deck()
	display_deck()

func _create_test_deck():
	#Test function to create a deck of 15 cards
	for i in range(15):
		var new_card = card.new("Card " + str(i + 1), "Effect", "Clause", "Type", "Sprite", i + 1)
		player_deck.append(new_card)

func draw_hand(selected_indices: Array):
	player_hand.clear()
	selected_indices.sort()
	selected_indices.reverse()
	for index in selected_indices:
		if index >= 0 and index < player_deck.size() and player_hand.size() < 7:
			player_hand.append(player_deck[index])
			player_deck.remove_at(index)

func select_card(card_index: int):
	if card_index >= 0 and card_index < player_hand.size():
		var selected_card = player_hand[card_index]
		player_hand.remove_at(card_index)
		player_deck.insert(0, selected_card)

func display_deck():
	card_rects.clear()
	for child in get_children():
		if child is CardDisplay:
			child.queue_free()
	for i in range(player_deck.size()):
		var card_display = CardDisplay.new(player_deck[i].card_name, player_deck[i].card_damage)
		card_display.position = Vector2(10, (i * 35) + 20)
		add_child(card_display)
		card_rects.append(Rect2(card_display.position, Vector2(200, 30)))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for i in range(card_rects.size()):
			if card_rects[i].has_point(event.position):
				print("card " + str(i + 1) + " clicked")
				draw_hand([i])
				# display_deck()
				break
