extends Card

class_name Backswing

func _init() -> void:
	card_name = "Backswing"
	effect = "Next time being damaged, damage the opponent of the same amount"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/BackswingCard.png"
	damage = 0
	value = 10
	items = []

func apply_effect(target, source) -> void:
	var backswing_effect = {
		"backswing": func(modified_damage: int) -> int:
			target.set_health(target.max_health, target.health - modified_damage)
			return modified_damage,
		"source": source,
		"target": target,
		"remaining_instances": 1
	}
	source.apply_temporary_effect(backswing_effect)
