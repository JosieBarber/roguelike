#enemy.gd

extends Node2D

class_name Enemy

signal enemy_health_changed(new_max_health, new_health)

var enemy_name: String
var status: String
var health: int
var max_health: int
var hand: Array
var deck: Array
var discard: Array
var active_deck: Array
var active_dot_effects: Array

var afflictions: Array

var selected_card_index: int = -1

func initialize(enemy_name_param: String, health_param: int, deck_param: Array):
	enemy_name = enemy_name_param
	set_health(health_param, health_param)
	hand = []
	deck = deck_param
	discard = []
	active_deck = []
	active_dot_effects = []

func prepare_enemy() -> void:
	var enemGen = enemyGeneration.new()
	var possible_enemies = enemGen.get_possible_enemies("Forest")
	var generated_enemy = possible_enemies[randi() % possible_enemies.size()]
	initialize(generated_enemy["enemy_name"], generated_enemy["health"], generated_enemy["deck"])
	generated_enemy.prepare_deck()
	

func prepare_deck() -> void:
	active_deck = deck.duplicate()

func prepare_hand() -> void:
	print("Preparing an enemy hand")
	hand.clear()
	active_deck.shuffle()
	if active_deck.size() > 7:
		hand = active_deck.slice(0, 7)
		active_deck = active_deck.slice(7, active_deck.size())
	elif active_deck.size() <= 7:
		print("enemy deck is less than 7 long, using rest of deck as hand")
		hand = active_deck.duplicate()
		print("enemy hand after taking rest of the deck is ", hand.size(), " long.")
		active_deck.clear()

func set_health(new_max_health: int, new_health: int) -> void:
	health = new_health
	max_health = new_max_health
	emit_signal("enemy_health_changed", max_health, health)
	print(enemy_name, " health is now ", health)
