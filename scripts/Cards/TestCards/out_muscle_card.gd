extends Card

class_name OutMuscle

func _init() -> void:
	card_name = "Out-Muscle"
	effect = "Drains target of health equal to current healt minus 25"
	clause = "Clause"
	card_type = "Physical"
	sprite = "res://assets/Card/OutMuscleCard.png"
	damage = 0
	value = 10
	items = []
	
func apply_effect(target, source) -> void:
	var set_damage =  max(source.health - (source.health/2), 0)
	var adjusted_damage = calculate_damage(target, source, set_damage, items)
	target.set_health(target.max_health, target.health - adjusted_damage)
	print(target.name, " was hit with ", card_name, ", and took ", adjusted_damage, " damage.")
