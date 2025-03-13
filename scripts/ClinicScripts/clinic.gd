extends Node2D

class_name Clinic

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var navigation_scene = get_parent().get_node("Navigation")
@onready var npc_ui = navigation_scene.get_parent().get_node("Ui").get_node("EnemyUi")


func _ready():
	npc_ui.visible = true
	_create_back_button()
	display_deck()

func _create_back_button():
	var button = Button.new()
	button.text = "Back to Navigation"
	button.size = Vector2(150, 30)
	button.position = Vector2(10, get_viewport().size.y - 40)
	add_child(button)
	button.connect("pressed", Callable(self, "_on_back_button_pressed"))

func _on_back_button_pressed():
	navigation_scene.visible = true
	npc_ui.visible = false
	
	queue_free()

func display_deck():
	var deck_object = get_node("Deck")
	for child in deck_object.get_children():
		child.queue_free()
	for i in range(player.deck.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card = player.deck[i]
		card_display.position = Vector2((i % 5 - 2) * 30, int(i / 5) * 42)
		card_display.connect("card_clicked", Callable(self, "_on_card_clicked"))
		deck_object.add_child(card_display)

func trade_card_for_health(card_index: int):
	if card_index >= 0 and card_index < player.deck.size():
		var card = player.deck[card_index]
		for i in range(player.deck.size()):
			if player.deck[i] == card:
				var new_health = min(player.health + card.value, player.max_health)
				player.set_health(player.max_health, new_health)
				player.deck.remove_at(i)
				print("Traded card for health. New health: ", player.health)
				break
	else:
		print("Invalid card index")

func transition_to_clinic():
	self.visible = true
	display_deck()

func _on_card_clicked(card, parent_node):
	for i in range(player.deck.size()):
		if player.deck[i] == card:
			trade_card_for_health(i)
			display_deck()
			break
