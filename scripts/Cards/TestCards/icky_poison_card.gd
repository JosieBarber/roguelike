extends Card

class_name IckyPoison

func _init() -> void:
	card_name = "Icky Poison"
	effect = "Deals 3 damage to opponent every turn for 5 turns"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/IckyPoisonCard.png"
	damage = 0
	value = 10
	items = []


func apply_effect(target, _source) -> void:
	print(target.name, " was hit with ", card_name, ", and took ", damage, " damage.")
	target.active_dot_effects.append({"damage": 3, "duration": 5, "card_type": "poison"})
