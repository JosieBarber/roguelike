extends Node2D

class_name Attack

@export var player: Player
@export var enemy: Enemy

var planning_scene: PackedScene

func _ready():
	# Preload the planning scene
	planning_scene = preload("res://scenes/Planning_Phase.tscn")
	
	# Print out the player's hand
	for card in player.player_hand:
		print("Card in hand: ", card.card_name)
	print("Player name: ", player.player_name)
	
	# Print out the enemy details
	print("Enemy name: ", enemy.enemy_name)
	print("Enemy health: ", enemy.enemy_health)

	print("Enemy deck: ")
	for card in enemy.enemy_deck:
		print(card.card_name)

	print("Enemy active deck: ")
	for card in enemy.active_deck:
		print(card.card_name)

	print("Enemy hand: ")
	for card in enemy.enemy_hand:
		print(card.card_name)
