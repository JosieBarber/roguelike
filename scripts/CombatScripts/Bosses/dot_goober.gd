extends Enemy

class_name DotGoober

func _ready() -> void:
	enemy_name = "Dot Goober"
	max_health = 60
	health = 60
	hand = []
	deck = [
		PreventativeMeasures.new(),
		PreventativeMeasures.new(),
		PreventativeMeasures.new(),
		PreventativeMeasures.new(),
		EffervescentVenom.new(),
		EffervescentVenom.new(),
		IckyPoison.new(),
		IckyPoison.new(),
		RapidDecomposition.new(),
		RapidDecomposition.new(),
		RapidDecomposition.new(),
		Acid.new(),
		BoneSplinters.new(),
		BoneSplinters.new(),
		Scratch.new(),
		Scratch.new(),
		Scratch.new(),
	]
	discard = []
	active_deck = []
	active_dot_effects = []
