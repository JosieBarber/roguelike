extends Card

class_name VisciousMockery

func _init() -> void:
	card_name = "Vicious Mockery"
	effect = "Deal 5 damage. If you have 30 or less health, deal an additional 5 damage. If you have 15 or less health, add a copy of one of your opponent's cards to your hand."
	clause = "Clause"
	card_type = "Type"
	sprite = "res://assets/Card/ViciousMockeryCard.png"
	damage = 5
	value = 10
	items = []

func apply_effect(target, source) -> void:
		var temp_damage = damage
		if source.health <= (3/8) * source.max_health:
			temp_damage += 5
		if source.health <= (3/16) * source.max_health:
			source.hand.insert(1, target.hand(0))
		var adjusted_damage = calculate_damage(target, source, temp_damage, items)
		target.set_health(target.max_health, target.health - adjusted_damage)
		
