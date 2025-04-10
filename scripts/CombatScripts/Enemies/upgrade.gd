extends Enemy

class_name UpgradeEnemy

func _ready() -> void:
    enemy_name = "Upgrade Enemy"
    max_health = 50
    health = 40
    hand = []
    deck = [
        EffervescentVenom.new(),
        EffervescentVenom.new(),
        EffervescentVenom.new(),
        BapCard.new(),
        BapCard.new(),
        BapCard.new(),
        Scratch.new(),
        Scratch.new(),
        Scratch.new(),
        SpiritAmplification.new(),
    ]
    discard = []
    active_deck = []
    active_dot_effects = []