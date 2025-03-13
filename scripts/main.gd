extends Node2D

@onready var player_instance: Player = get_node("Player")
@onready var navigation_scene = get_node("Navigation")

func _ready():
	player_instance.initialize("JosiePosie", 20)
	player_instance._create_test_deck()
	navigation_scene.visible = true
