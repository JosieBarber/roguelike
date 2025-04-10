extends Card

class_name Acid

func _init() -> void:
	card_name = "Acid"
	effect = "Deals 5 damage at the start of next 2 turns"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/AcidCard.png"
	damage = 0
	value = 10
	items = []


func apply_effect(target, _source) -> void:
	DOT.add_damage_effect(target, 5, 2, 1)
