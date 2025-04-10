extends Enemy

class_name DamageEnemy

func _ready() -> void:
	enemy_name = "Damage Enemy"
	max_health = 50
	health = 38
	hand = []
	deck = [
		BlankCard.new("", "", "", "", "res://assets/Card/TCOYSCard.png", 0, 0, []),
		BlankCard.new("", "", "", "", "res://assets/Card/TCOYSCard.png", 0, 0, []),
		BlankCard.new("", "", "", "", "res://assets/Card/TCOYSCard.png", 0, 0, []),
		BlankCard.new("", "", "", "", "res://assets/Card/TCOYSCard.png", 0, 0, []),
		BlankCard.new("", "", "", "", "res://assets/Card/TCOYSCard.png", 0, 0, []),
		EgoTear.new(),
		EgoTear.new(),
		CrushingBlow.new(),
		CrushingBlow.new(),
		CrushingBlow.new(),
		BlankCard.new("", "", "", "", "res://assets/Card/TCOYSCard.png", 0, 0, []),
		BlankCard.new("", "", "", "", "res://assets/Card/TCOYSCard.png", 0, 0, []),
	]
	discard = []
	active_deck = []
	active_dot_effects = []
