extends Node2D

var player_instance = Player

func _ready():
	player_instance = get_node("Player")
	player_instance.initialize("JosiePosie", 100)
	player_instance._create_test_deck()
	#player_instance.copy_deck()

	
