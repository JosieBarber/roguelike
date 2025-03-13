extends Node2D

class_name Planning

@onready var player: Player = get_parent().get_parent().get_node("Player")
@onready var enemy: Enemy = get_parent().get_node("Enemy")
@onready var ready_button = get_parent().get_node("ReadyButton")

@onready var ui_scene = get_parent().get_parent().get_node('Ui')
@onready var location_panel = ui_scene.get_node('location_panel')

@onready var active_deck_object: Node2D = get_node("Active Deck")
@onready var prepared_hand_object: Node2D = get_node("Prepared Hand")


var selected_card_index: int = -1
var selected_cards: Array = []

func _ready():
	#var ready_button = get_parent().get_node("ReadyButton")
	ready_button.connect("ready_button_clicked", Callable(self, "_on_ready_button_clicked"))
	location_panel.visible = false
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
	for child in active_deck_object.get_children():
		child.queue_free()
	for i in range(player.active_deck.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card = player.active_deck[i]
		card_display.scale = Vector2(0.66, 0.66)
		card_display.position = Vector2((i % 5 - 2) * 25, int(i / 5) * 35)
		card_display.connect("card_clicked", Callable(self, "_on_card_clicked"))
		card_display.add_to_group("CardDisplays")
		active_deck_object.add_child(card_display)

func display_prepared_hand():
	for child in prepared_hand_object.get_children():
		child.queue_free()
	for i in range(selected_cards.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card = selected_cards[i]
		card_display.position = Vector2((i - (selected_cards.size() - 1) / 2.0) * 30, 0)
		card_display.scale = Vector2(0.78, 0.78)
		card_display.connect("card_clicked", Callable(self, "_on_card_clicked"))
		card_display.add_to_group("CardDisplays")
		prepared_hand_object.add_child(card_display)
		#adjust_hitbox(card_display, i == selected_cards.size() - 1)

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
	
	location_panel.visible = true
	var attack_scene = get_parent().get_node("Attack_Phase")
	attack_scene.visible = true
	enemy.prepare_hand()
	attack_scene.transition_to_attack_phase()

func refill_active_deck():
	if player.active_deck.size() == 0:
		player.active_deck = player.deck.duplicate()
		var player_played_node = get_parent().get_node("Attack_Phase/PlayerPlayed")
		for child in player_played_node.get_children():
			child.queue_free()
	if enemy.active_deck.size() == 0:
		enemy.active_deck = enemy.deck.duplicate()
		var enemy_played_node = get_parent().get_node("Attack_Phase/EnemyPlayed")
		for child in enemy_played_node.get_children():
			child.queue_free()
