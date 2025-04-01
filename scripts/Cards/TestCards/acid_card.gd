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
	DOT.add_effect(target, 5, 2, 1) # 5 damage, 2 turns, 1 turn interval
	print(card_name, " applied a damage-over-time effect to ", target.name, " for 2 turns, dealing 5 damage per turn.")
