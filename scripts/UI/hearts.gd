extends Node2D

class_name Hearts

var max_health: int
var current_health: int

func _ready():
	update_hearts()

func update_hearts():
	if max_health <= 0:
		return  # Prevent division by zero
	
	var health_per_heart = max_health / 5
	for i in range(5):
		var heart = get_node("Heart" + str(i + 1))
		var heart_health = current_health - (i * health_per_heart)
		if heart_health >= health_per_heart:
			heart.frame = 0
		elif heart_health > 0:
			var frame_index = int(4 - (heart_health / health_per_heart) * 4)
			heart.frame = clamp(frame_index, 1, 4)
		else:
			heart.frame = 4
		heart.visible = true
