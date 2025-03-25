extends Card

class_name HeartAttackCard

func _init() -> void:
	card_name = "Heart Attack"
	effect = "Deals damage"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/HeartAttackCard.png"
	damage = 10
	value = 15
	items = []
	
func apply_effect(target, source) -> void:
	source.set_health(source.max_health, source.health - 5)
	target.set_health(target.max_health, target.health - 5)
