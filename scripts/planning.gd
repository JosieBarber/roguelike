extends Node2D

class_name Planning

var player: Player
var enemy: Enemy
var selected_card_index: int = -1
var selected_cards: Array = []

var deck_rects: Array = []
var selected_rects: Array = []


func _ready():
	player = get_parent().get_parent().get_node("Player")
	enemy = get_parent().get_node("Enemy")
	_create_draw_button()

func draw_hand():
	player.player_hand.clear()
	for card in selected_cards:
		player.player_hand.append(card)
	selected_cards.clear()
	display_prepared_hand() #this shouldn't be needed but it is (?) 
	transition_to_attack_phase()

func select_card(card_index: int):
	if player.active_deck.size() > card_index and selected_cards.size() < 7:
		var selected_card = player.active_deck[card_index]
		selected_cards.append(selected_card)
		player.active_deck.remove_at(card_index)
	elif selected_cards.size() >= 7:
		print("Hand is full")
	display_deck()
	display_prepared_hand()

func deselect_card(card_index: int):
	var deselected_card = selected_cards[card_index]
	player.active_deck.append(deselected_card)
	selected_cards.remove_at(card_index)
	display_deck()
	display_prepared_hand()
	
func display_deck():
	var active_deck_object = get_node("Active Deck")
	deck_rects.clear()
	for child in active_deck_object.get_children():
			child.queue_free()
	for i in range(player.active_deck.size()):
		var card_display = CardDisplay.new(player.active_deck[i].card_name, player.active_deck[i].card_damage)
		card_display.position = Vector2(10, (i * 35) + 20)
		var hitbox_position = Vector2(card_display.position[0] + active_deck_object.position[0], 
									  card_display.position[1] + active_deck_object.position[1])
		deck_rects.append(Rect2(hitbox_position, Vector2(200, 30)))
		active_deck_object.add_child(card_display)

func display_prepared_hand():
	var prepared_hand_object = get_node("Prepared Hand")
	selected_rects.clear()
	for child in prepared_hand_object.get_children():
		child.queue_free()
	for i in range(selected_cards.size()):
		var card_display = CardDisplay.new(selected_cards[i].card_name, selected_cards[i].card_damage)
		card_display.position = Vector2(10, (i * 35) + 20)
		var hitbox_position = Vector2(card_display.position[0] + prepared_hand_object.position[0], 
									  card_display.position[1] + prepared_hand_object.position[1])
		selected_rects.append(Rect2(hitbox_position, Vector2(200, 30)))
		prepared_hand_object.add_child(card_display)


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for i in range(deck_rects.size()):
			if deck_rects[i].has_point(event.position):
				select_card(i)
				break
		for i in range(selected_rects.size()):
			if selected_rects[i].has_point(event.position):
				deselect_card(i)
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
	self.visible = false
	deck_rects.clear()
	
	var attack_scene = get_parent().get_node("Attack_Phase")
	attack_scene.visible = true
	enemy.prepare_hand()
	attack_scene.transition_to_attack_phase()
