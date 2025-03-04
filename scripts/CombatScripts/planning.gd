extends Node2D

class_name Planning

var player: Player
var enemy: Enemy
var selected_card_index: int = -1
var selected_cards: Array = []

func _ready():
	var ready_button = get_parent().get_node("ReadyButton")
	ready_button.connect("ready_button_clicked", Callable(self, "_on_ready_button_clicked"))
	
	player = get_parent().get_parent().get_node("Player")
	enemy = get_parent().get_node("Enemy")
	display_deck()

func draw_hand():
	player.hand.clear()
	for card in selected_cards:
		player.hand.append(card)
	selected_cards.clear()
	display_prepared_hand()
	transition_to_attack_phase()

func select_card(card: Card):
	for i in range(player.active_deck.size()):
		if player.active_deck[i] == card and selected_cards.size() < 7:
			selected_cards.append(card)
			player.active_deck.remove_at(i)
			break
	display_deck()
	display_prepared_hand()

func deselect_card(card: Card):
	for i in range(selected_cards.size()):
		if selected_cards[i] == card:
			player.active_deck.append(card)
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
		card_display.card = player.active_deck[i]
		card_display.position = Vector2((i % 5 - 2) * 30, int(i / 5) * 42)
		card_display.connect("card_clicked", Callable(self, "_on_card_clicked"))
		card_display.add_to_group("CardDisplays")
		active_deck_object.add_child(card_display)

func display_prepared_hand():
	var prepared_hand_object = get_node("Prepared Hand")
	for child in prepared_hand_object.get_children():
		child.queue_free()
	for i in range(selected_cards.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card = selected_cards[i]
		card_display.position = Vector2(0, i * 5)
		card_display.scale = Vector2(1.3, 1.3)
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

func _on_card_clicked(card, parent_node):
	if parent_node.name == "Active Deck":
		select_card(card)
	elif parent_node.name == "Prepared Hand":
		deselect_card(card)
		
func _on_ready_button_clicked():
	if self.visible:
		draw_hand()

func transition_to_attack_phase():
	self.visible = false
	
	var attack_scene = get_parent().get_node("Attack_Phase")
	attack_scene.visible = true
	enemy.prepare_hand()
	attack_scene.transition_to_attack_phase()

func refill_active_deck():
	if player.active_deck.size() == 0:
		player.active_deck = player.deck.duplicate()
	if enemy.active_deck.size() == 0:
		enemy.active_deck = enemy.deck.duplicate()
