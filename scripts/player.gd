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
var temporary_effects: Array

var afflictions: Array

var selected_card_index: int = -1
var card_rects: Array = []
var cards_played_count: int = 0

func initialize(player_name_param: String, health_param: int):
	player_name = player_name_param
	set_health(health_param, health_param)
	hand = []
	deck = []
	discard = []
	active_deck = []
	active_dot_effects = []
	afflictions = []
	temporary_effects = []

func _ready():
	pass
	
func copy_deck():
	active_deck.clear()
	active_deck = deck.duplicate()

func _create_test_deck():
	deck.clear()
	var test_cards = [
		BapCard.new(),
		Scratch.new(),
		LightningParry.new(),
		Backswing.new(),
		SpiritAmplification.new(),
		SiphonLife.new(),
		PreventativeMeasures.new()
	]
	
	print("Loaded test cards: ", test_cards)

	# Ensure the deck has exactly 7 cards
	for card in test_cards:
		deck.append(card)

func prepare_deck() -> void:
	active_deck = deck.duplicate()

func set_health(new_max_health: int, new_health: int):
	max_health = new_max_health
	if max_health <= new_health:
		health = max_health
	else:
		health = new_health
	emit_signal("player_health_changed", max_health, health)
	print(player_name, " health is now ", health)
	
func apply_temporary_effect(effect):
	temporary_effects.append(effect)
	DOT.active_effects.append(effect)
