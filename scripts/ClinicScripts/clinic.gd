extends Node2D

class_name Clinic

var player: Player
var deck_rects: Array = []

func _ready():
	if get_parent().get_node("Player"):
		player = get_parent().get_node("Player")
	if not player:
		player = Player.new()
		get_parent().call_deferred("add_child", player)
		player.initialize("JosiePosie", 10)
		player._create_test_deck()
	_create_back_button()

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
	deck_rects.clear()
	self.visible = false

func display_deck():
	var deck_object = get_node("Deck")
	deck_rects.clear()
	for child in deck_object.get_children():
		child.queue_free()
	for i in range(player.deck.size()):
		var card_display = CardDisplay.new(player.deck[i].card_name, player.deck[i].damage)
		card_display.position = Vector2(10, (i * 35) + 20)
		var hitbox_position = Vector2(0, 0)
		var hitbox = Area2D.new()
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = RectangleShape2D.new()
		collision_shape.shape.extents = Vector2(100, 15)
		hitbox.position = hitbox_position
		hitbox.add_child(collision_shape)
		card_display.add_child(hitbox)
		deck_rects.append(hitbox)
		deck_object.add_child(card_display)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for i in range(deck_rects.size()):
			var global_position = deck_rects[i].get_global_transform_with_canvas().origin
			var global_rect = Rect2(global_position, Vector2(200, 30))
			if global_rect.has_point(event.position):
				trade_card_for_health(i)
				display_deck()
				break

func trade_card_for_health(card_index: int):
	if card_index >= 0 and card_index < player.deck.size():
		var card = player.deck[card_index]
		player.health += card.value
		player.deck.remove_at(card_index)
		#player.discard.append(card)
		print("Traded card for health. New health: ", player.health)
	else:
		print("Invalid card index")

func transition_to_clinic():
	self.visible = true
	display_deck()
