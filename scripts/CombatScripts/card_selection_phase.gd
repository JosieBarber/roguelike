extends Control

class_name CardSelectionPhase

@onready var card_container = $CardContainer
@onready var player: Player = get_tree().get_first_node_in_group("player")

@onready var ready_button = get_parent

var selected_cards: Array = []
var max_selectable_cards: int = 3

var displayed_cards: Array = []

func _ready():
	if card_container == null:
		push_error("CardContainer node is missing or not properly set up in the scene!")
	else:
		print("CardContainer initialized successfully.")

func set_enemy_deck(enemy_deck: Array) -> void:
	if card_container == null:
		push_error("CardContainer is null. Cannot add cards.")
		return
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	while displayed_cards.size() < 5 and enemy_deck.size() > 0:
		var random_index = rng.randi_range(0, enemy_deck.size() - 1)
		displayed_cards.append(enemy_deck[random_index])
		enemy_deck.remove_at(random_index)
	display_cards()

func select_card(card):
	if selected_cards.size() < max_selectable_cards:
		selected_cards.append(card)
		displayed_cards.erase(card)
		display_cards()


func display_cards():
	for child in card_container.get_children():
		child.queue_free()
	for i in range(displayed_cards.size()):
		var card_display = preload("res://scenes/assets/CardDisplay.tscn").instantiate()
		card_display.card = displayed_cards[i]
		card_display.hoverable = true
		card_display.position = Vector2((i - (displayed_cards.size() - 1) / 2.0) * 40, 0)
		card_display.connect("card_clicked", Callable(self, "_on_card_clicked"))
		card_container.add_child(card_display)

func _on_card_clicked(card, _parent):
	if card not in selected_cards:
		print("Selected:", card.card_name)
		select_card(card)
	if selected_cards.size() >= max_selectable_cards:
		confirm_selection()

func confirm_selection():
	for card in selected_cards:
		player.deck.append(card)
	get_parent().queue_free()
	Events._navigation_focus.emit(true, true)
