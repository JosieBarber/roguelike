extends Card

class_name Fireball

func _init() -> void:
	card_name = "Fireball"
	effect = "Effect"
	clause = "Clause"
	card_type = "Physical"
	sprite = "res://assets/Card/TCOYSCard.png"
	damage = 3
	value = 11
	items = []

func apply_effect(target, source) -> void:
	# Fireball deals damage and applies a burn effect
	target.set_health(target.max_health, target.health - damage)
	print(target.name, " was hit with ", card_name, ", and took ", damage, " damage.")
	target.active_dot_effects.append({"damage": 1, "duration": 3, "card_type": "Burn"})
