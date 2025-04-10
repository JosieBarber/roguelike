extends Enemy

class_name BlockingEnemy

func _ready() -> void:
	enemy_name = "Card Play Enemy"
	max_health = 50
	health = 25
	hand = []
	deck = [
		Backswing.new(),
        Backswing.new(),
        LightningParry.new(),
        LightningParry.new(),
        LightningParry.new(),
        BapCard.new(),
        BapCard.new(),
        BapCard.new(),
        Scratch.new(),
        Scratch.new(),
        Scratch.new(),
        Backswing.new(),
        LightningParry.new(),
        Scratch.new(),
	]
	discard = []
	active_deck = []
	active_dot_effects = []
