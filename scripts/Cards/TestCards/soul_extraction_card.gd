extends Card

class_name SoulExtraction

func _init() -> void:
	card_name = "Soul Extraction"
	effect = "Steals a card from opponents deck until used"
	clause = "None"
	card_type = "Type"
	sprite = "res://assets/Card/SoulExtractionCard.png"
	damage = 0
	value = 10
	items = []


func apply_effect(target, source) -> void:
	var rng = RandomNumberGenerator.new()
	var card_index = rng.randi_range(0, target.active_deck.size() - 1)
	if target.active_deck.size() > 0:
		source.active_deck.append(target.active_deck[card_index])
		target.active_deck.remove_at(card_index)
	
