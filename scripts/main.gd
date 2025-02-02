extends Node2D

func _ready():
	var player_instance = $Player
	player_instance.initialize("Player1", 100)
