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
		BlankCard.new("", "", "", "", "res://assets/Card/TCOYSCard.png", 0, 0, []),
		BapCard.new(),
		BapCard.new(),
		BlankCard.new("", "", "", "", "res://assets/Card/TCOYSCard.png", 0, 0, []),
		BlankCard.new("", "", "", "", "res://assets/Card/TCOYSCard.png", 0, 0, []),
		HeartAttackCard.new(),
		HeartAttackCard.new(),
		BapCard.new(),
		BapCard.new(),
	]
	discard = []
	active_deck = []
	active_dot_effects = []
