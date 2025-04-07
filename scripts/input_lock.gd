extends Node

var input_locked = false
var lock_duration = 0.02

func lock_input(duration: float) -> void:
	input_locked = true
	await get_tree().create_timer(duration).timeout
	input_locked = false
	
func is_input_locked() -> bool:
	return input_locked

func _lock_scene_input() -> void:
	if input_locked:
		return
	lock_input(lock_duration)
