extends Card

class_name EffervescentVenom

func _init() -> void:
	card_name = "Effervescent Venom"
	effect = "Increases damage"
	clause = "Next 6 instances of damage done by user by are increased 2"
	card_type = "Type"
	sprite = "res://assets/Card/EffervescentVenomCard.png"
	damage = 0
	value = 10
	items = []

func apply_effect(target, source) -> void:
	var venom_effect = {
		"damage_bonus": 2,
		"remaining_instances": 6
	}
	source.apply_temporary_effect(venom_effect)
	print(card_name, " applied a temporary effect to ", source.name, ": next 6 instances of damage are increased by 2.")
