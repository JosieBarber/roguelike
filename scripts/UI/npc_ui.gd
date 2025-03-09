extends Node2D

var enemy: Enemy

func _ready():
	pass
	# Try to connect to the enemy's signal if the enemy exists
	# _try_connect_to_enemy()

# func _try_connect_to_enemy():
# 	if get_parent().get_parent().has_node("Combat"):
# 		enemy = get_parent().get_parent().get_node("Combat").get_node("Enemy")
# 		enemy.connect("enemy_health_changed", Callable(self, "_on_enemy_health_changed"))
# 		print("connected UI to enemy")
# 	else:
# 		# Retry after a short delay if the enemy is not yet available
# 		await get_tree().create_timer(0.1).timeout
# 		_try_connect_to_enemy()

func _on_enemy_health_changed(new_max_health: int, new_health: int):
	var hearts_node = get_node("MetalPanel").get_node("Hearts")
	hearts_node.max_health = new_max_health
	hearts_node.current_health = new_health
	hearts_node.update_hearts()
