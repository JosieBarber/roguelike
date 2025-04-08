extends Node2D

class_name Planning

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var enemy: Enemy = get_parent().get_node("Enemy")
@onready var ready_button = get_parent().get_node("ReadyButton")

@onready var ui_scene = get_tree().get_first_node_in_group("Ui")
@onready var location_panel = ui_scene.location_panel

@onready var active_deck_object: Node2D = $"Active Deck/PlanningPhaseCardTrayMask"
@onready var prepared_hand_object: Node2D = get_node("Prepared Hand")


var selected_card_index: int = -1
var selected_cards: Array = []

var scroll_offset: float = 0.0
var scroll_speed: float = 10.0

func _ready():
	ready_button.connect("ready_button_clicked", Callable(self, "_on_ready_button_clicked"))
	location_panel.visible = false
	display_deck()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("scroll_up"):
		scroll_offset = max(scroll_offset - scroll_speed, 0)
	elif Input.is_action_just_pressed("scroll_down"):
		var max_scroll = max(0, (int((player.active_deck.size() - 1) / 4) * 35 + 35) - active_deck_object.texture.get_size().y)
		scroll_offset = min(scroll_offset + scroll_speed, max_scroll)
	_update_active_deck_positions()

	var tray_global_rect = Rect2(
		active_deck_object.global_position - active_deck_object.texture.get_size() / 2,
		active_deck_object.texture.get_size()
	)

	for card_display in active_deck_object.get_children():
		if card_display is Node2D and card_display.has_node("Area2D/CollisionShape2D"):
			var collision_shape = card_display.get_node("Area2D/CollisionShape2D") as CollisionShape2D
			if collision_shape and collision_shape.shape is RectangleShape2D:
				var rect_size = (collision_shape.shape as RectangleShape2D).size
				var card_global_rect = Rect2(
					card_display.global_position - rect_size / 2,
					rect_size
				)
				card_display.hoverable = card_global_rect.intersects(tray_global_rect)

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
		if child is CardDisplay:
			child.queue_free()
	for i in range(player.active_deck.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		print(player.active_deck[i])
		card_display.card = player.active_deck[i]
		card_display.scale = Vector2(0.60, 0.60)
		card_display.position = Vector2((i % 5 - 2) * 25, int(i / 5) * 35 - 17 - scroll_offset)
		card_display.hoverable = true
		card_display.connect("card_clicked", Callable(self, "_on_card_clicked"))
		card_display.add_to_group("CardDisplays")
		active_deck_object.add_child(card_display)

func _update_active_deck_positions() -> void:
	for i in range(active_deck_object.get_children().size()):
		var card_display = active_deck_object.get_child(i)
		if card_display is Node2D:
			card_display.position = Vector2(
				(i % 5 - 2) * 25,
				int(i / 5) * 35 - 17 - scroll_offset
			)

func display_prepared_hand():
	for child in prepared_hand_object.get_children():
		child.queue_free()
	for i in range(selected_cards.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card = selected_cards[i]
		card_display.position = Vector2((i - (selected_cards.size() - 1) / 2.0) * 30, 0)
		card_display.scale = Vector2(0.70, 0.70)
		card_display.hoverable = true
		card_display.connect("card_clicked", Callable(self, "_on_card_clicked"))
		card_display.add_to_group("CardDisplays")
		prepared_hand_object.add_child(card_display)

func _on_card_clicked(card, parent_node):
	if parent_node == active_deck_object:
		select_card(card)
	elif parent_node.name == "Prepared Hand":
		deselect_card(card)
		
func _on_ready_button_clicked():
	if self.visible:
		draw_hand()

func transition_to_attack_phase():
	self.visible = false
	
	location_panel.visible = true
	
	for child in active_deck_object.get_children():
		if child is CardDisplay:
			child.queue_free()
	
	var attack_scene = get_parent().get_node("Attack_Phase")
	attack_scene.visible = true

	player.cards_played_count = 0
	enemy.cards_played_count = 0

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
