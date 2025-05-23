extends Card

class_name RapidDecomposition

func _init() -> void:
	card_name = "Rapid Decomposition"
	effect = "Deals 2 damage at the start of next 7 turns"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/RapidDecompositionCard.png"
	damage = 0
	value = 10
	items = []


func apply_effect(target, _source) -> void:
	DOT.add_damage_effect(target, 2, 7, 1)
