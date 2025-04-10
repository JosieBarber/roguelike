extends Enemy

class_name Bonk

var alternate_hand: bool = true  # Tracks whether to play the first or second hand

func _ready() -> void:
	enemy_name = "Bonk"
	max_health = 60
	health = 60
	hand = []
	deck = [
		Scratch.new(),
		ViciousMockery.new(),
		LightningParry.new(),
		Backswing.new(),
		HeartAttackCard.new(),
		SiphonLife.new(),
		CataclysmCard.new(),
		SpiritAmplification.new(),
	] 
	discard = []
	active_deck = []
	active_dot_effects = []

func prepare_hand() -> void:
	hand.clear()
	if alternate_hand:
		# First hand
		hand.append(Backswing.new())
		hand.append(Scratch.new())
		hand.append(LightningParry.new())
		hand.append(ViciousMockery.new())
	else:
		# Second hand
		hand.append(HeartAttackCard.new())
		hand.append(SiphonLife.new())
		hand.append(SpiritAmplification.new())
		hand.append(CataclysmCard.new())

	
	# Alternate for the next turn
	alternate_hand = not alternate_hand