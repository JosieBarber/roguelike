extends Card

class_name MaladyOfHubris

func _init() -> void:
	card_name = "Icky Poison"
	effect = ""
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/MaladyOfHubrisCard.png"
	damage = 0
	value = 10
	items = []


func apply_effect(target, source) -> void:
	print(target.name, " was hit with ", card_name, ", and took ", damage, " damage.")
	var dot_damage = target.cards_played_count  # Calculate DOT damage based on cards played
	print("Malady of hubris will deal: ", dot_damage, " per turn.")
	DOT.add_damage_effect(target, dot_damage, 3, 1)
