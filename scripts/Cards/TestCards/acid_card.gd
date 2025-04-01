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
	DOT.add_effect(target, 5, 2, 1)
