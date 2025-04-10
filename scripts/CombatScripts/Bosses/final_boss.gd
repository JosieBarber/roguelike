extends Enemy

class_name FinalBossEnemy

var alternate_hand: bool = true  # Tracks whether to play big damage or blocking hand

func _ready() -> void:
	enemy_name = "Final Boss"
	max_health = 70
	health = 70
	hand = []
	deck = [
		PreventativeMeasures.new(),
		BloomingMutation.new(),
		ShriekingEchos.new(),
		SpiritAmplification.new(),
		GigaDrain.new(),
		MomentOfClarity.new(),
		MomentOfClarity.new(),
	]
	discard = []
	active_deck = []
	active_dot_effects = []

func prepare_hand() -> void:
	hand.clear()
	if alternate_hand:
		# Big damage hand
		hand.append(PreventativeMeasures.new())
		hand.append(BloomingMutation.new())
		hand.append(ShriekingEchos.new())
		hand.append(SpiritAmplification.new())
		hand.append(GigaDrain.new())
	else:
		# Blocking hand
		hand.append(MomentOfClarity.new())

	# Alternate for the next turn
	alternate_hand = not alternate_hand

	# If the deck is empty, refill it
	if active_deck.size() == 0:
		active_deck = deck.duplicate()
