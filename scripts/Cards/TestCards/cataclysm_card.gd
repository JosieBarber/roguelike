extends Card

class_name CataclysmCard

func _init() -> void:
	card_name = "Cataclysm"
	effect = "Deals 2 damage for every 4 health the user is missing"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/CataclysmCard.png"
	damage = 0
	value = 5
	items = []

func apply_effect(target, source):
	var missing_health = source.max_health - source.health
	var damage_to_deal = int(missing_health / 4) * 2
	var adjusted_damage = calculate_damage(target, source, damage_to_deal, items)
	target.set_health(target.max_health, target.health - adjusted_damage)
