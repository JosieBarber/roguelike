extends CardItem

class_name MultiplierCardItem 

var damage_multiplier: float

func _init():
	self.damage_multiplier = damage_multiplier

func modify_damage(card: Card) -> void:
	card.damage = card.damage * damage_multiplier
