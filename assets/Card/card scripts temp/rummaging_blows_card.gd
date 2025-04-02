extends Card

class_name RummagingBlows

func _init() -> void:
	card_name = "Rummaging Blows"
	effect = "Deals damage, if kills, take more loot"
	clause = "Clause"
	card_type = "Physical"
	sprite = "res://assets/Card/TCOYSCard.png"
	damage = 3
	value = 2
	items = []
	
func apply_effect(target, source) -> void:
	var adjusted_damage = calculate_damage(target, source, target.hand.size(),items)
	target.set_health(target.max_health, target.health - adjusted_damage)
	print(target.name, " was hit with ", card_name, ", and took ", adjusted_damage, " damage.")
	#Make takeable loot bigger
