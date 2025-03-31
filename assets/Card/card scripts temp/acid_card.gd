extends Card

class_name Acid

func _init() -> void:
	card_name = "Acid"
	effect = "Deals damage"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/AcidCard.png"
	damage = 0
	value = 10
	items = []


func apply_effect(target, source) -> void:
	#target.set_health(target.max_health, target.health - damage)
	print(target.name, " was hit with ", card_name, ", and took ", damage, " damage.")
	target.active_dot_effects.append({"damage": 5, "duration": 2, "card_type": "acid"})
