extends Card

class_name BlankCard



func _init(card_name_param: String, effect_param: String, clause_param: String, card_type_param: String, sprite_param: String, damage_param: int, value_param: int, items_param: Array):
	card_name = card_name_param
	effect = effect_param
	clause = clause_param
	card_type = card_type_param
	sprite = sprite_param
	damage = damage_param
	value = value_param
	items = items_param
