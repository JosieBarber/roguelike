extends Card

class_name BloomingMutation

func _init() -> void:
	card_name = "Blooming Mutation"
	effect = "Makes the next card's effect happen twice if the source is at max health"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/BloomingMutationCard.png"
	damage = 0
	value = 10
	items = []

func apply_effect(target, source) -> void:
	var double_effect = {
		"_modify_effect": func(card: Card, _target, _source) -> void:
			if source.health == source.max_health:
				card.apply_effect(target, source),
		"remaining_instances": 1
	}
	source.apply_temporary_effect(double_effect)
	print(card_name, " applied a temporary effect to ", source.name, ": the next card's effect will happen twice.")
