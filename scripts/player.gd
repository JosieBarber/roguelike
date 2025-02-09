#player.gd

extends Node2D

class_name Player

var player_name: String
var status: String
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
	health = health_param
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
	#Test function to create a deck of 15 cards
	deck.clear()
	for i in range(15):
		var new_card = Card.new("Card " + str(i + 1), "Effect", "Clause", "Type", "Sprite", 1)
		deck.append(new_card)
