extends Node2D

class_name Clinic

var player: Player

func _ready():
	#if get_parent().get_node("Player"):
		#player = get_parent().get_node("Player")
	if not player:
		player = Player.new()
		get_parent().call_deferred("add_child", player)
		player.initialize("JosiePosie", 10)
		player._create_test_deck()

func trade_card_for_health(card_index: int):
	if card_index >= 0 and card_index < player.hand.size():
		var card = player.hand[card_index]
		player.health += card.value
		player.hand.remove_at(card_index)
		player.discard.append(card)
		print("Traded card for health. New health: ", player.health)
	else:
		print("Invalid card index")
