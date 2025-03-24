extends Node2D

@onready var player_inventory_mask = $PlayerInventory/Mask
@onready var mask_hitbox = $PlayerInventory/Area2D/MaskHitbox
@onready var shopping_cart_object = $ClinicHeart/ShoppingCart
@onready var ready_button = $ReadyButton

@onready var player = get_tree().get_first_node_in_group("player")
@onready var clinic = get_parent()

var player_deck: Array = []
var scroll_offset: float = 0.0
var scroll_speed: float = 10.0
var shopping_cart: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck = player.active_deck
	_display_player_deck()
	ready_button.connect("ready_button_clicked", Callable(self, "_sell_shopping_cart_items"))

func _display_player_deck():
	for child in player_inventory_mask.get_children():
		child.queue_free()
	for i in range(player_deck.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.connect("card_clicked", Callable(self, "_on_card_clicked"))
		card_display.card = player_deck[i]
		card_display.hoverable = true
		card_display.scale = Vector2(0.66, 0.66)
		card_display.position = Vector2((i % 4 - 1.5) * 25, int(i / 4) * 35 - 7)  # 4 cards per row
		player_inventory_mask.add_child(card_display)

func _sell_shopping_cart_items():
	for card in shopping_cart:
		trade_card_for_health(card, shopping_cart)
		#print("sold a card")
	shopping_cart.clear()
	for child in shopping_cart_object.get_children():
		child.queue_free()
	player.deck = player_deck.duplicate()

func trade_card_for_health(card: Card, col: Array):
	for i in range(col.size()):
		if col[i] == card:
			var new_health = min(player.health + int(0.5 * card.value), player.max_health)
			player.set_health(player.max_health, new_health)
			print("Traded card for health. New health: ", player.health)
			break

func _display_shopping_cart(card) -> void:
	# Create and display the new shopping card
	var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
	card_display.card = card
	card_display.scale = Vector2(0.66, 0.66)
	card_display.position = Vector2(randf_range(-4, 4), randf_range(-6, 6))
	card_display.rotation_degrees = randf_range(-15, 15)
	shopping_cart_object.add_child(card_display)

func _on_card_clicked(card, parent_node): 
	if parent_node.get_parent().name == "PlayerInventory":
		if player.active_deck.size() > 1:
			for i in range(player_deck.size()):
				if player_deck[i] == card:
					shopping_cart.append(card)
					player_deck.remove_at(i)
					_display_shopping_cart(card)
					_display_player_deck()
					break
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dev_back"):
		clinic._transition_from_health_shop()
	
	# Calculate the global rectangle of PlayerInventory
	var inventory_global_rect = Rect2(
		player_inventory_mask.global_position - player_inventory_mask.texture.get_size() / 2,
		player_inventory_mask.texture.get_size()
	)

	# Check if the cursor is within the PlayerInventory
	if inventory_global_rect.has_point(get_global_mouse_position()):
		if Input.is_action_just_pressed("scroll_up"):
			scroll_offset = max(scroll_offset - scroll_speed, 0)
		elif Input.is_action_just_pressed("scroll_down"):
			var max_scroll = max(0, (int((player_deck.size() - 1) / 4) * 35 + 35) - player_inventory_mask.texture.get_size().y)
			scroll_offset = min(scroll_offset + scroll_speed, max_scroll)
		_update_player_card_positions()

func _update_player_card_positions() -> void:
	for i in range(player_deck.size()):
		var card_display = player_inventory_mask.get_child(i)
		if card_display is Node2D:
			card_display.position = Vector2(
				(i % 4 - 1.5) * 25,
				int(i / 4) * 35 - 7 - scroll_offset
			)
