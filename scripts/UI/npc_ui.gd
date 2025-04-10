extends Node2D

var enemy: Enemy
@onready var health_label = $MetalPanel/Health

func _on_enemy_health_changed(new_max_health: int, new_health: int):
	var hearts_node = get_node("MetalPanel").get_node("Hearts")
	health_label.text = str(new_health)
	hearts_node.max_health = new_max_health
	hearts_node.current_health = new_health
	hearts_node.update_hearts()
