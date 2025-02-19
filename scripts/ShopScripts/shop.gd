extends Node2D

#TEST REFERENCE
var player: Player
var test_cards = []
var displayed_cards = []
var card_rects: Array = []

func _ready():
	if get_parent().get_node("Player"):
		player = get_parent().get_node("Player")
	if not player:
		player = Player.new()
		get_parent().call_deferred("add_child", player)
		player.initialize("JosiePosie", 10)
		player._create_test_deck()
	load_test_cards()
	display_random_cards()
	_create_back_button()

func load_test_cards():
	var dir = DirAccess.open("res://scripts/Cards/TestCards/")
	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".gd"):
				var card_script = load("res://scripts/Cards/TestCards/" + file_name)
				if card_script:
					test_cards.append(card_script)
				else:
					print("Failed to load card script: ", file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
		print("Loaded test cards: ", test_cards)
	else:
		print("Failed to open directory: res://scripts/Cards/TestCards/")

func display_random_cards():
	print("Displaying random cards")
	var random_cards = []
	while random_cards.size() < 3 and test_cards.size() > 0:
		var random_index = randi() % test_cards.size()
		random_cards.append(test_cards[random_index])
		test_cards.remove_at(random_index)
	print("Random cards: ", random_cards)
	
	var item_list = get_node("ItemList")
	card_rects.clear()
	for child in item_list.get_children():
		child.queue_free()
	for i in range(random_cards.size()):
		var card_instance = random_cards[i].new()
		var card_display = CardDisplay.new(card_instance.card_name, card_instance.damage)
		card_display.position = Vector2(10, (i * 60) + 20)
		var hitbox_position = Vector2(0, 0)
		var hitbox = Area2D.new()
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = RectangleShape2D.new()
		collision_shape.shape.extents = Vector2(100, 10)
		hitbox.position = hitbox_position
		hitbox.add_child(collision_shape)
		card_display.add_child(hitbox)
		
		var value_label = Label.new()
		value_label.text = str(card_instance.value)
		value_label.name = "ValueLabel"
		card_display.add_child(value_label)
		value_label.position = Vector2(10, 40)
		
		card_rects.append(hitbox)
		item_list.add_child(card_display)
		displayed_cards.append(card_display)

	update_card_display_colors()

func update_card_display_colors():
	for card_display in displayed_cards:
		var value_label = card_display.get_node("ValueLabel")
		var card_value = int(value_label.text)
		if card_value >= player.health:
			value_label.modulate = Color(0.8, 0, 0)
		else:
			value_label.modulate = Color(1, 1, 1)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for i in range(card_rects.size()):
			var global_position = card_rects[i].get_global_transform_with_canvas().origin
			var global_rect = Rect2(global_position, Vector2(200, 30))
			if global_rect.has_point(event.position):
				_on_Card_pressed(i)
				break

func _on_Card_pressed(card_index: int):
	var card_display = displayed_cards[card_index]
	var card_instance = card_display.card_instance
	var card_value = card_instance.value
	if player.health > card_value:
		player.health -= card_value
		player.deck.append(card_instance)
		displayed_cards.erase(card_display)
		card_display.queue_free()
		# Update UI and player health display here
		update_card_display_colors()
	else:
		print("Not enough health to buy this card")

func transition_to_shop():
	self.visible = true
	update_card_display_colors()
	
func _create_back_button():
	var button = Button.new()
	button.text = "Back to Navigation"
	button.size = Vector2(150, 30)
	button.position = Vector2(10, get_viewport().size.y - 40)
	add_child(button)
	button.connect("pressed", Callable(self, "_on_back_button_pressed"))

func _on_back_button_pressed():
	var navigation_scene = get_parent().get_node("Navigation")
	navigation_scene.visible = true
	self.visible = false
