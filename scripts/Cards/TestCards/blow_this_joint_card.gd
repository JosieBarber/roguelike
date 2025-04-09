extends Card

class_name BlowThisJointCard

func _init() -> void:
	card_name = "Lets Blow This Joint"
	effect = "Deals damage"
	clause = "None"
	card_type = "Magic"
	sprite = "res://assets/Card/BlowThisJointCard.png"
	damage = 3
	value = 5
	items = []
	
func apply_effect(target, source) -> void:
	var rng = RandomNumberGenerator.new()
	var card_index = rng.randi_range(1, target.hand.size() - 1)
	if target.hand.size() >= 1:
		target.active_deck.append(target.hand[card_index])
		target.hand.remove_at(card_index)
	
	var adjusted_damage = calculate_damage(target, source, target.hand.size(),items)
	target.set_health(target.max_health, target.health - adjusted_damage)


#Fix this shit trust :3
