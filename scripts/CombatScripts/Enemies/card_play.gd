extends Enemy

class_name CardPlayEnemy

func _ready() -> void:
	enemy_name = "Card Play Enemy"
	max_health = 50
	health = 42
	hand = []
	deck = [
		BlowThisJointCard.new(),
		BlowThisJointCard.new(),
		BapCard.new(),
		BapCard.new(),
		SoulExtraction.new(),
		BoneSplinters.new(),
		BapCard.new(),
		BoneSplinters.new(),
		MaladyOfHubris.new(),
		MaladyOfHubris.new(),
		BapCard.new(),
		BapCard.new(),
	]
	discard = []
	active_deck = []
	active_dot_effects = []

func prepare_hand() -> void:
	hand.clear()
	var non_malady_cards = []
	var malady_cards = []
	
	# Separate MaladyOfHubris cards from the rest
	for card in active_deck:
		if card is MaladyOfHubris:
			malady_cards.append(card)
		else:
			non_malady_cards.append(card)
	
	# Shuffle both lists
	non_malady_cards.shuffle()
	malady_cards.shuffle()
	
	# Draw up to 5 non-Malady cards
	hand = non_malady_cards.slice(0, min(5, non_malady_cards.size()))
	
	# Add one MaladyOfHubris card if available
	if malady_cards.size() > 0:
		hand.append(malady_cards.pop_front())
	
	# Remove drawn cards from active_deck
	for card in hand:
		active_deck.erase(card)
	
	# If not enough cards for a 6-card hand, shuffle and add remaining cards
	if hand.size() < 6:
		active_deck.shuffle()
		while hand.size() < 6 and active_deck.size() > 0:
			hand.append(active_deck.pop_front())
