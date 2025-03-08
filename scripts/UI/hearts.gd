extends Node2D

class_name Hearts

var max_health: int
var current_health: int

func _ready():
	update_hearts()

func update_hearts():
	for i in range(int(max_health / 4)):
		var heart = get_node("Heart" + str(i + 1))
		var heart_health = current_health - (i * 4)
		if i == 0 or i == 4:
			if heart_health >= 4:
				heart.frame = 0  # Full heart
			elif heart_health > 0:
				heart.frame = 4 - heart_health  # Damaged heart
			else:
				heart.visible = false
			heart.visible = heart_health > 0  # Ensure heart is visible if it has health
		else:
			if heart_health >= 4:
				heart.frame = 1  # Full heart
			elif heart_health > 0:
				heart.frame = 5 - heart_health  # Damaged heart
			else:
				heart.visible = false
