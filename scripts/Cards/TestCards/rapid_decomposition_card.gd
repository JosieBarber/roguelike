extends Card

class_name RapidDecomposition

func _init() -> void:
	card_name = "Rapid Decomposition"
	effect = ""
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/RapidDecompositionCard.png"
	damage = 0
	value = 10
	items = []


func apply_effect(target, source) -> void:
	DOT.add_effect(target, 2, 7, 1)
