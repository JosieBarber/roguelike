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
	display_deck()

func draw_hand():
	player.hand.clear()
	for card in selected_cards:
		player.hand.append(card)
	selected_cards.clear()
	display_prepared_hand() #this shouldn't be needed but it is (?) 
	transition_to_attack_phase()

func select_card(card_name: String, card_damage: int, card_items: Array):
	for i in range(player.active_deck.size()):
		if player.active_deck[i].card_name == card_name and player.active_deck[i].damage == card_damage and player.active_deck[i].items == card_items and selected_cards.size() < 7:
			var selected_card = player.active_deck[i]
			selected_cards.append(selected_card)
			player.active_deck.remove_at(i)
			break
	display_deck()
	display_prepared_hand()

func deselect_card(card_name: String, card_damage: int, card_items: Array):
	for i in range(selected_cards.size()):
		if selected_cards[i].card_name == card_name and selected_cards[i].damage == card_damage and selected_cards[i].items == card_items:
			var deselected_card = selected_cards[i]
			player.active_deck.append(deselected_card)
			selected_cards.remove_at(i)
			break
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
		card_display.connect("card_clicked", Callable(self, "_on_card_clicked"))
		card_display.add_to_group("CardDisplays")
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
		card_display.position = Vector2(0, i * 10)
		card_display.connect("card_clicked", Callable(self, "_on_card_clicked"))
		card_display.add_to_group("CardDisplays")
		prepared_hand_object.add_child(card_display)
		adjust_hitbox(card_display, i == selected_cards.size() - 1)

func adjust_hitbox(card_display, is_topmost):
	var area = card_display.get_node("Area2D")
	if is_topmost:
		area.collision_layer = 1
	else:
		area.collision_layer = 0

func _on_card_clicked(card_name, card_damage, card_items, parent_node):
	if parent_node.name == "Active Deck":
		select_card(card_name, card_damage, card_items)
	elif parent_node.name == "Prepared Hand":
		deselect_card(card_name, card_damage, card_items)

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
