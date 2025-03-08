extends Node2D

var player_instance = Player

func _ready():
	player_instance = get_node("Player")
	player_instance.initialize("JosiePosie", 20)
	player_instance._create_test_deck()
	# player_instance.copy_deck()
	
	# Start with the navigation scene
	var navigation_scene = get_node("Navigation")
	navigation_scene.visible = true

	# player_instance.set_health(20)
