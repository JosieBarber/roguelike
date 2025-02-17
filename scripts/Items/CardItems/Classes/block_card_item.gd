extends CardItem

class_name BlockCardItem

var block_amount: int

func _init(block_amount: int):
	self.block_amount = block_amount

func block_damage(damage: int) -> int:
	return max(damage - block_amount, 0)
