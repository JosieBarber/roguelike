extends Node2D

class_name Attack

@export var player: Player
@export var enemy: Enemy

func _ready():
	# Print out the player's hand
	for card in player.player_hand:
		print("Card in hand: ", card.card_name)
	print("Player name: ", player.player_name)
	
	# Print out the enemy details
	print("Enemy name: ", enemy.enemy_name)
	print("Enemy health: ", enemy.enemy_health)
	for card in enemy.enemy_deck:
		print("Enemy card: ", card.card_name)
