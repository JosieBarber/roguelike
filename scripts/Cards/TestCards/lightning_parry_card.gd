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

func _apply_block(_target, source, incoming_damage: int, _items: Array):
	incoming_damage = int(incoming_damage / 2)
	source.set_health(source.max_health, source.health - incoming_damage)
	return incoming_damage
