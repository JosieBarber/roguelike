#enemy.gd

extends Node2D

class_name Enemy

var enemy_name: String
var enemy_status: String
var enemy_health: int
var enemy_hand: Array
var enemy_deck: Array
var enemy_discard: Array
var active_deck: Array

var selected_card_index: int = -1

func initialize(enemy_name_param: String, health: int, deck: Array):
	enemy_name = enemy_name_param
	enemy_health = health
	enemy_hand = []
	enemy_deck = deck
	enemy_discard = []
	active_deck = []

func prepare_enemy() -> void:
	var enemGen = enemyGeneration.new()
	var possible_enemies = enemGen.get_possible_enemies("Forest")
	var generated_enemy = possible_enemies[randi() % possible_enemies.size()]
	initialize(generated_enemy["enemy_name"], generated_enemy["enemy_health"], generated_enemy["enemy_deck"])
	generated_enemy.prepare_deck()
	

func prepare_deck() -> void:
	active_deck = enemy_deck.duplicate()

func prepare_hand() -> void:
	print("Preparing an enemy hand")
	enemy_hand.clear()
	active_deck.shuffle()
	if active_deck.size() > 7:
		enemy_hand = active_deck.slice(0, 7)
		active_deck = active_deck.slice(7, active_deck.size())
	elif active_deck.size() <= 7:
		print("enemy deck is less than 7 long, using rest of deck as hand")
		enemy_hand = active_deck.duplicate()
		print("enemy hand after taking rest of the deck is", enemy_hand.size(), " long.")
		active_deck.clear()

func _ready():
	pass
