#player.gd

extends Node2D

class_name player

var player_name: String
var player_status: String
var player_health: int
var player_hand: Array
var player_deck: Array
var player_discard: Array


func _init(player_name_param: String, health: int):
	player_name = player_name_param
	player_health = health

func _ready():
	# Initialize the player when it is added to the scene
	pass
