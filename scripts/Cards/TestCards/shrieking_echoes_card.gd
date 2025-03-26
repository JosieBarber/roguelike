extends Card

class_name ShriekingEchoes

func _init() -> void:
	card_name = "Shrieking Echoes"
	effect = "Effect"
	clause = "Clause"
	card_type = "Physical"
	sprite = "res://assets/Card/ShriekingEchoesCard.png"
	damage = 3
	value = 10
	items = []
	
func apply_effect(target, source) -> void:
	target.set_health(target.max_health, target.health - damage)
	#print(target.name, " was hit with ", card_name, ", and took ", damage, " damage.")
	target.active_dot_effects.append({"damage": 5, "duration": 3, "card_type": "Burn"})
	
