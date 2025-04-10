extends Enemy

class_name SelfHealEnemy

func _ready() -> void:
	enemy_name = "Card Play Enemy"
	max_health = 50
	health = 20
	hand = []
	deck = [
		OutMuscle.new(),
		OutMuscle.new(),
		SiphonLife.new(),
		SiphonLife.new(),
		SiphonLife.new(),
		GigaDrain.new(),
		BapCard.new(),
		BapCard.new(),
		Scratch.new(),
		Scratch.new(),
	]
	discard = []
	active_deck = []
	active_dot_effects = []
