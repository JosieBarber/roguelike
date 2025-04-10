extends Node2D

@onready var player_inventory_sprite = $PlayerInventory
@onready var player_inventory_mask = $PlayerInventory/Mask
@onready var mask_hitbox = $PlayerInventory/Area2D/MaskHitbox
@onready var card_pool_mask = $CardPool/Mask
@onready var card_pool_sprite = $CardPool
# @onready var card_pool_mask_hitbox = $CardPool/Area2D/MaskHitbox
@onready var shopping_cart_object = $CardPool/ShoppingCart
@onready var ready_button = $ReadyButton
@onready var exit_button = $ExitButton

@onready var player = get_tree().get_first_node_in_group("player")
@onready var clinic = get_parent()


var player_deck: Array = []
var scroll_offset: float = 0.0
var scroll_speed: float = 10.0
var card_pool: Array = []
var card_pool_scroll_offset: float = 0.0
var shopping_cart: Array = []

func _ready() -> void:
	load_test_cards()
	_display_player_deck()
	_display_card_pool()
	ready_button.connect("ready_button_clicked", Callable(self, "_buy_shopping_cart_items"))
	exit_button.connect("exit_button_clicked", Callable(clinic, "_transition_from_card_shop"))
func _display_player_deck():
	player_deck = player.deck
	for child in player_inventory_mask.get_children():
		child.queue_free()
	for i in range(player_deck.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card = player_deck[i]
		card_display.hoverable = true
		card_display.scale = Vector2(0.66, 0.66)
		card_display.position = Vector2((i % 4 - 1.5) * 25, int(i / 4) * 35 - 7)  # 4 cards per row
		player_inventory_mask.add_child(card_display)

func _display_card_pool():
	for child in card_pool_mask.get_children():
		child.queue_free()
	for i in range(card_pool.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card = card_pool[i]
		card_display.connect("card_clicked", Callable(self, "_on_card_clicked"))
		card_display.hoverable = true
		card_display.scale = Vector2(0.66, 0.66)
		card_display.position = Vector2((i % 3 - 1) * 25, int(i / 3) * 35 - 7)  # 3 cards per row
		card_pool_mask.add_child(card_display)

func _process(delta: float) -> void:
	if self.visible:
		if Input.is_action_just_pressed("dev_back"):
			clinic._transition_from_card_shop()

		var inventory_global_rect = Rect2(
			player_inventory_sprite.global_position - player_inventory_sprite.texture.get_size() / 2,
			player_inventory_sprite.texture.get_size()
		)

		var inventory_mask_global_rect = Rect2(
			player_inventory_mask.global_position - player_inventory_mask.texture.get_size() / 2,
			player_inventory_mask.texture.get_size()
		)
		

		for card_display in player_inventory_mask.get_children():
			if card_display is Node2D and card_display.has_node("Area2D/CollisionShape2D"):
				var collision_shape = card_display.get_node("Area2D/CollisionShape2D") as CollisionShape2D
				if collision_shape and collision_shape.shape is RectangleShape2D:
					var rect_size = (collision_shape.shape as RectangleShape2D).size
					var card_global_rect = Rect2(
						card_display.global_position - rect_size / 2,
						rect_size
					)
					card_display.hoverable = card_global_rect.intersects(inventory_mask_global_rect) and inventory_global_rect.has_point(get_global_mouse_position())

		# Check if the cursor is within the PlayerInventory
		if inventory_global_rect.has_point(get_global_mouse_position()):
			if Input.is_action_just_pressed("scroll_up"):
				scroll_offset = max(scroll_offset - scroll_speed, 0)
			elif Input.is_action_just_pressed("scroll_down"):
				var max_scroll = max(0, (int((player_deck.size() - 1) / 4) * 35 + 35) - player_inventory_mask.texture.get_size().y)
				scroll_offset = min(scroll_offset + scroll_speed, max_scroll)
			_update_player_card_positions()
#
		#for card_display in player_inventory_mask.get_children():
			#card_display.hoverable = inventory_global_rect.has_point(get_global_mouse_position())

		# Handle scrolling for CardPool
		var card_pool_global_rect = Rect2(
			card_pool_sprite.global_position - card_pool_sprite.texture.get_size() / 2,
			card_pool_sprite.texture.get_size()
		)

		var card_pool_global_mask_rect = Rect2(
			card_pool_mask.global_position - card_pool_mask.texture.get_size() / 2,
			card_pool_mask.texture.get_size()
		)
		
		for card_display in card_pool_mask.get_children():
			if card_display is Node2D and card_display.has_node("Area2D/CollisionShape2D"):
				var collision_shape = card_display.get_node("Area2D/CollisionShape2D") as CollisionShape2D
				if collision_shape and collision_shape.shape is RectangleShape2D:
					var rect_size = (collision_shape.shape as RectangleShape2D).size
					var card_global_rect = Rect2(
						card_display.global_position - rect_size / 2,
						rect_size
					)
					card_display.hoverable = card_global_rect.intersects(card_pool_global_mask_rect) and card_pool_global_rect.has_point(get_global_mouse_position())


		if card_pool_global_rect.has_point(get_global_mouse_position()):
			if Input.is_action_just_pressed("scroll_up"):
				card_pool_scroll_offset = max(card_pool_scroll_offset - scroll_speed, 0)
			elif Input.is_action_just_pressed("scroll_down"):
				var max_scroll = max(0, (int((card_pool.size() - 1) / 3) * 35 + 35) - card_pool_mask.texture.get_size().y)
				card_pool_scroll_offset = min(card_pool_scroll_offset + scroll_speed, max_scroll)

			_update_card_pool_positions()

func _update_player_card_positions() -> void:
	for i in range(player_deck.size()):
		var card_display = player_inventory_mask.get_child(i)
		if card_display is Node2D:
			card_display.position = Vector2(
				(i % 4 - 1.5) * 25,
				int(i / 4) * 35 - 7 - scroll_offset
			)

func _update_card_pool_positions() -> void:
	for i in range(card_pool.size()):
		var card_display = card_pool_mask.get_child(i)
		if card_display is Node2D:
			card_display.position = Vector2(
				(i % 3 - 1) * 25,
				int(i / 3) * 35 - 7 - card_pool_scroll_offset
			)

func _on_card_clicked(card, parent_node): 
	if parent_node.get_parent().name == "CardPool":
		for i in range(card_pool.size()):
			if card_pool[i] == card:
				shopping_cart.append(card)
				card_pool.remove_at(i)
				_display_shopping_cart(card)
				_display_card_pool()
				break
		
func _display_shopping_cart(card) -> void:
	# Create and display the new shopping card
	var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
	card_display.card = card
	card_display.scale = Vector2(0.66, 0.66)
	card_display.position = Vector2(randf_range(-4, 4), randf_range(-6, 6))
	card_display.rotation_degrees = randf_range(-15, 15)
	shopping_cart_object.add_child(card_display)

func _buy_shopping_cart_items():
	for card in shopping_cart:
		var card_value = card.value
		if player.health > card_value:
			# Deduct the card's value from the player's health
			player.set_health(player.max_health, player.health - card_value)
			player.deck.append(card)
			print(player.deck.size())
		else:
			print("Not enough health to buy card: ", card.card_name)
	_display_player_deck()

	# Clear the shopping cart
	shopping_cart.clear()
	for child in shopping_cart_object.get_children():
		child.queue_free()


func load_test_cards():
	var dir = DirAccess.open("res://scripts/Cards/TestCards/")
	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".gd"):
				var card_script = load("res://scripts/Cards/TestCards/" + file_name)
				if card_script:
					# Instantiate the card script into an object
					var card_instance = card_script.new()
					card_pool.append(card_instance)
				else:
					print("Failed to load card script: ", file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
		print("Loaded test cards: ", card_pool.size())
	else:
		print("Failed to open directory: res://scripts/Cards/TestCards/")
