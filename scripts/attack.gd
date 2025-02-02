extends Node2D

class_name Attack

@export var player: Player

func _ready():
	for card in player.player_hand:
		print("Card in hand: ", card.card_name)
	print("Player name: ", player.player_name)
