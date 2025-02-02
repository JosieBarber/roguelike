#enemy.gd

extends Node2D

class_name Enemy

var enemy_name: String
var enemy_status: String
var enemy_health: int
var enemy_hand: Array
var enemy_deck: Array
var enemy_discard: Array

var selected_card_index: int = -1

func initialize(player_name_param: String, health: int, deck: Array):
	enemy_name = player_name_param
	enemy_health = health
	enemy_hand = deck
	enemy_deck = []
	enemy_discard = []

func _ready():
	# Initialize the player when it is added to the scene
	pass
