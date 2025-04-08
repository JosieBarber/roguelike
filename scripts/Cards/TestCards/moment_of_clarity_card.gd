extends Card

class_name MomentOfClarity

func _init() -> void:
	card_name = "Moment of Clarity"
	effect = "Blocks all damage for the round"
	clause = "Only works if no other cards are played"
	card_type = "Type"
	sprite = "res://assets/Card/MomentOfClarityCard.png"
	damage = 0
	value = 20
	items = []

func apply_effect(_target, source) -> void:
	if source.cards_played_count == 0 and source.hand.size() == 1:
		var clarity_effect = {
			"damage_prevention": true,
			"remaining_instances": 9999,  # Effectively infinite 
			"round_end_removal": true,    # Until the round ends
			"source": source
		}
		source.apply_temporary_effect(clarity_effect)
		print(card_name, " applied a temporary effect to ", source.name, ": blocks all damage for the round.")
