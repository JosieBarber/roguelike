extends Node2D

signal ready_button_clicked()

func _ready():
	var area = $Area2D
	area.connect("input_event", Callable(self, "_on_area_input_event"))

	
func _on_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("ready_button_clicked")

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		emit_signal("ready_button_clicked")

	
