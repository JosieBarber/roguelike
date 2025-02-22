extends Node2D

class_name Planning

var player: Player
var enemy: Enemy
var selected_card_index: int = -1
var selected_cards: Array = []

func _ready():
	player = get_parent().get_parent().get_node("Player")
	enemy = get_parent().get_node("Enemy")
	_create_draw_button()

func draw_hand():
	player.hand.clear()
	for card in selected_cards:
		player.hand.append(card)
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
	for child in active_deck_object.get_children():
		child.queue_free()
	for i in range(player.active_deck.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card_name = player.active_deck[i].card_name
		card_display.card_damage = player.active_deck[i].damage
		card_display.card_items = player.active_deck[i].items
		card_display.position = Vector2((i % 4 - 1.5) * 40, int(i / 4) * 60)
		active_deck_object.add_child(card_display)

func display_prepared_hand():
	var prepared_hand_object = get_node("Prepared Hand")
	for child in prepared_hand_object.get_children():
		child.queue_free()
	for i in range(selected_cards.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card_name = selected_cards[i].card_name
		card_display.card_damage = selected_cards[i].damage
		card_display.card_items = selected_cards[i].items
		card_display.position = Vector2((i % 3 - 1) * 210, int(i / 3) * 100)
		prepared_hand_object.add_child(card_display)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# No need to manually check hitboxes, the card displays handle their own input
		pass

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
	
	var attack_scene = get_parent().get_node("Attack_Phase")
	attack_scene.visible = true
	enemy.prepare_hand()
	attack_scene.transition_to_attack_phase()
