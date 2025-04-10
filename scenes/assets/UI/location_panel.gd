extends Sprite2D

@onready var coin = $LocationCoin/LocationIcon

func _ready() -> void:
	coin.frame = 1
enum Locations { COMBAT, CLINIC, BLANK, BOSS }

func _set_coin_face(location: int):
	match location:
				Locations.COMBAT:
					flip_coin()
					coin.frame = 0
				Locations.CLINIC:
					flip_coin()
					coin.frame = 2
				Locations.BLANK:
					flip_coin()
					coin.frame = 1
				Locations.BOSS:
					flip_coin()
					coin.frame = 0

func flip_coin():
	pass
