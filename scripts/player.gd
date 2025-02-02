#player.gd

extends Node2D

class_name Player

var player_name: String
var player_status: String
var player_health: int
var player_hand: Array
var player_deck: Array
var player_discard: Array
var active_deck: Array

var selected_card_index: int = -1
var card_rects: Array = []

func initialize(player_name_param: String, health: int):
	player_name = player_name_param
	player_health = health
	player_hand = []
	player_deck = []
	player_discard = []
	active_deck = []

func _ready():
	# Initialize the player when it is added to the scene
	pass
