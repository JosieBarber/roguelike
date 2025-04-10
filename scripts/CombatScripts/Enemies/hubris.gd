extends Enemy

class_name HubrisEnemy

func _ready() -> void:
	enemy_name = "Hubris Enemy"
	max_health = 50
	health = 30
	deck = [
		MaladyOfHubris.new(),
        MaladyOfHubris.new(),
        MaladyOfHubris.new(),
        MaladyOfHubris.new(),
        MaladyOfHubris.new(),
        MaladyOfHubris.new(),
        MaladyOfHubris.new(),

	]
	discard = []
	active_deck = []
	active_dot_effects = []
