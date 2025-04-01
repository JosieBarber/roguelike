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
	
func apply_effect(target, source) -> void:
	var temp_effect = {
		"_modify_damage": func(damage: int) -> void:
			damage += 5
	}
	source.hand[1].temporary_effects.append(temp_effect)
	for i in range(1,3):
		if source.hand[i]:
			source.hand[i].temporary_effects.append(temp_effect)
