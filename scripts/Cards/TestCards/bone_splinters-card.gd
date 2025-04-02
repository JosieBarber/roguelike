extends Card

class_name BoneSplinters

func _init() -> void:
	card_name = "Bone Splinters"
	effect = "Deals damage"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/BoneSplintersCard.png"
	damage = 2
	value = 5
	items = []


func apply_effect(target, source) -> void:
	var adjusted_damage = calculate_damage(target, source, damage ,items)
	target.set_health(target.max_health, target.health - adjusted_damage)
	print(target.name, " was hit with ", card_name, ", and took ", adjusted_damage, " damage.")
	target.hand.insert(1, BlankCard.new("","","","","res://assets/Card/BoneSplintersCard.png",0,0,[]))
