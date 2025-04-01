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
	var adjusted_damage = calculate_damage(target, source, damage, items)

	source.set_health(source.max_health, source.health - (adjusted_damage / 2))
	target.set_health(target.max_health, target.health - adjusted_damage)
