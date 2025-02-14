extends Item

class_name CardItem

class BlockCardItem extends CardItem:
    var block_amount: int

    func _init(block_amount: int):
        self.block_amount = block_amount

    func block_damage(damage: int) -> int:
        return max(damage - block_amount, 0)

class ModifierCardItem extends CardItem:
    var damage_multiplier: float

    func _init(damage_multiplier: float):
        self.damage_multiplier = damage_multiplier

    func modify_damage(damage: int) -> int:
        return int(damage * damage_multiplier)

class TypeChangeCardItem extends CardItem:
    var new_type: String

    func _init(new_type: String):
        self.new_type = new_type

    func change_type() -> String:
        return new_type