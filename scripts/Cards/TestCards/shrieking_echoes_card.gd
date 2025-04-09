extends Card

class_name ShriekingEchos

func _init() -> void:
	card_name = "Shrieking Echos"
	effect = "Deals damage"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/ShriekingEchoesCard.png"
	damage = 0
	value = 7
	items = []
	
func apply_effect(_target, source) -> void:
	var temp_effect = {
		"_modify_damage": func(modified_damage: int) -> int:
			modified_damage += 5
			return modified_damage
	}
	
	
	for i in range(1, min(3,source.hand.size() - 1)):
		if source.hand[i]:
			source.hand[i].temporary_effects.append(temp_effect)
