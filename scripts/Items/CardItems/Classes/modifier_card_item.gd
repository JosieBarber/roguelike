extends CardItem

class_name ModifierCardItem 

var damage_multiplier: float

func _init():
	self.damage_multiplier = damage_multiplier

func modify_damage(damage: int) -> int:
	return int(damage * damage_multiplier)
