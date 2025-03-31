extends Card

class_name GigaDrain

func _init() -> void:
	card_name = "Gigadrain"
	effect = "Deals damage"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/GigadrainCard.png"
	damage = 6
	value = 5
	items = []
	
func apply_effect(target, source):
	target.set_health(target.max_health, target.health - damage)
	source.set_healt(source.max_health, source.health + damage)
