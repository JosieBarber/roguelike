extends Node2D

#TEST REFERENCE
var player: Player
var test_cards = []
var displayed_cards = []

func _ready():
	# self.visible = true
	
	if not player:
		player = Player.new()
		get_parent().call_deferred("add_child", player)
		player.initialize("JosiePosie", 10)
		player._create_test_deck()
		
	load_test_cards()
	display_random_cards()

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
		var card_display = Button.new()
		card_display.text = card_instance.card_name
		add_child(card_display)
		displayed_cards.append(card_display)

		card_display.position = Vector2(150, 100 * displayed_cards.size())
		var value_label = Label.new()
		value_label.text = str(card_instance.value)
		value_label.name = "ValueLabel"
		card_display.add_child(value_label)
		value_label.position = Vector2(10, 40)

		card_display.connect("pressed", Callable(self, "_on_Card_pressed").bind(card_instance, card_display))

	update_card_display_colors()

func update_card_display_colors():
	for card_display in displayed_cards:
		var value_label = card_display.get_node("ValueLabel")
		var card_value = int(value_label.text)
		if card_value >= player.health:
			value_label.modulate = Color(0.8, 0, 0)
		else:
			value_label.modulate = Color(1, 1, 1)

func _on_Card_pressed(card_instance, card_display):
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
