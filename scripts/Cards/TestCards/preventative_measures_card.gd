extends Card

class_name PreventativeMeasures

func _init() -> void:
	card_name = "Preventative Measures"
	effect = "Prevents damage"
	clause = "Next 2 instances of damage to the user are prevented"
	card_type = "Type"
	sprite = "res://assets/Card/PreventativeMeasuresCard.png"
	damage = 0
	value = 15
	items = []

func apply_effect(_target, source) -> void:
	var prevention_effect = {
		"damage_prevention": true,
		"remaining_instances": 2
	}
	source.apply_temporary_effect(prevention_effect)
