extends Card

class_name LightningParry

func _init() -> void:
	card_name = "Lightning Parry"
	effect = "Blocks half of incoming damage and reflects it back"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/LightningParryCard.png"
	damage = 0
	value = 10
	items = []

func _apply_block(target, source, damage: int, items: Array):
	damage = int(damage / 2)
	source.set_health(source.max_health, source.health - damage)
	return damage
