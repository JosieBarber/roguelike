extends Card

class_name SpiritAmplification

func _init() -> void:
	card_name = "Spirit Amplification"
	effect = "Deals 3 damage to target and increases damage of next card played by damage dealt"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/SpiritAmplificationCard.png"
	damage = 3
	value = 7
	items = []
	
func apply_effect(target, source) -> void:
	var adjusted_damage = calculate_damage(target, source, damage, items)
	target.set_health(target.max_health, target.health - adjusted_damage)
	
	# Add a temporary effect to amplify damage
	var temp_effect = {
		"_modify_damage": func(damage_param: int) -> int:
			damage_param += adjusted_damage
			return damage_param
	}
	if source.hand.size() >= 2:
		source.hand[1].temporary_effects.append(temp_effect)
		print(source.hand[1].card_name, " has been amplified to do ", calculate_damage(target, source, source.hand[1].damage, source.hand[1].items), " damage.")

	
