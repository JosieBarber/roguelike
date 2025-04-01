extends Card

class_name SiphonLife

func _init() -> void:
	card_name = "Siphon Life"
	effect = "Deals damage"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/SiphonLifeCard.png"
	damage = 2
	value = 5
	items = []
	
func apply_effect(target, source):
	var adjusted_damage = calculate_damage(target, source, target.hand.size(),items)
	target.set_health(target.max_health, target.health - adjusted_damage)
	source.set_health(source.max_health, source.health + adjusted_damage)
