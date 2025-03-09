extends Node2D

class_name Hearts

var max_health: int
var current_health: int

func _ready():
	update_hearts()

func update_hearts():
	for i in range(5):  # Always iterate over 5 hearts
		var heart = get_node("Heart" + str(i + 1))
		var heart_health = current_health - (i * (max_health / 5))
		if heart_health >= (max_health / 5):
			if i == 0 or i == 4:
				heart.frame = 0
			else: 
				heart.frame = 1
		elif heart_health > 0:
			heart.frame = int((max_health / 5) - heart_health)
		else:
			heart.visible = false
		heart.visible = heart_health > 0
