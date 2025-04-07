extends Node2D


@onready var player: Player = get_tree().get_first_node_in_group("player")
var test_cards = []
var displayed_cards = []

func _ready():
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
	
	for card_script in random_cards:
		var card_instance = card_script.new()
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card = card_instance
		card_display.position = Vector2((displayed_cards.size() % 3 - 1) * 30, 0)
		card_display.connect("card_clicked", Callable(self, "_on_card_clicked"))
		var item_list = get_node("ItemList")
		item_list.add_child(card_display)
		displayed_cards.append(card_display)

		var value_label = Label.new()
		value_label.text = str(card_instance.value)
		value_label.name = "ValueLabel"
		card_display.add_child(value_label)
		value_label.position = Vector2(10, 30)

	update_card_display_colors()

func update_card_display_colors():
	for card_display in displayed_cards:
		var value_label = card_display.get_node("ValueLabel")
		if value_label:
			var card_value = int(value_label.text)
			if card_value >= player.health:
				value_label.modulate = Color(0.8, 0, 0)
			else:
				value_label.modulate = Color(1, 1, 1)
		else:
			print("ValueLabel not found in card_display")

func _on_card_clicked(card, parent_node):
	var card_value = card.value
	if player.health > card_value:
		player.set_health(player.max_health, player.health - card_value)
		player.deck.append(card)
		displayed_cards.erase(parent_node)
		parent_node.hide()  
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
	InputLock._lock_scene_input()
	var navigation_scene = get_parent().get_node("Navigation")
	var npc_ui = navigation_scene.get_parent().get_node("Ui").get_node("EnemyUi")
	
	navigation_scene.visible = true
	npc_ui.visible = false
	queue_free()
