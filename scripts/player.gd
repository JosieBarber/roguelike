#player.gd

extends Node2D

class_name Player

signal player_health_changed(new_max_health, new_health)

var player_name: String
var status: String
var max_health: int
var health: int
var hand: Array
var deck: Array
var discard: Array
var active_deck: Array
var active_dot_effects: Array

var selected_card_index: int = -1
var card_rects: Array = []

func initialize(player_name_param: String, health_param: int):
	player_name = player_name_param
	set_health(health_param, health_param)
	hand = []
	deck = []
	discard = []
	active_deck = []
	active_dot_effects = []

func _ready():
	pass
	
func copy_deck():
	active_deck.clear()
	active_deck = deck.duplicate()

func _create_test_deck():
	# Test function to create a deck of 15 random cards from the test card folder
	deck.clear()
	var test_cards = []
	var dir = DirAccess.open("res://scripts/Cards/TestCards/")
	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".gd"):
				var card_script = load("res://scripts/Cards/TestCards/" + file_name)
				if card_script:
					test_cards.append(card_script)
			file_name = dir.get_next()
		dir.list_dir_end()
		print("Loaded test cards: ", test_cards)
	else:
		print("Failed to open directory: res://scripts/Cards/TestCards/")
	
	while deck.size() < 10 and test_cards.size() > 0:
		var random_index = randi() % test_cards.size()
		var card_instance = test_cards[random_index].new()
		deck.append(card_instance)
		test_cards.remove_at(random_index)

func set_health(new_max_health: int, new_health: int):
	health = new_health
	max_health = new_max_health
	emit_signal("player_health_changed", max_health, health)
