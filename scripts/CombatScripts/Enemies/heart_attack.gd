extends Enemy

class_name HeartAttackEnemy

func _ready() -> void:
    enemy_name = "Heart Attack Enemy"
    max_health = 50
    health = 50
    hand = []
    deck = [
        BapCard.new(),
        BapCard.new(),
        BapCard.new(),
        BapCard.new(),
        BapCard.new(),
        BapCard.new(),
        HeartAttackCard.new(),
        HeartAttackCard.new(),
        HeartAttackCard.new(),
        BapCard.new(),
        BapCard.new(),
    ]
    discard = []
    active_deck = []
    active_dot_effects = []