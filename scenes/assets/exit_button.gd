extends Node2D

signal exit_button_clicked()
@onready var sprite = $Sprite2D

var space_bar_pressed: bool = false

func _ready():
	var area = $Area2D
	space_bar_pressed = false
	area.connect("input_event", Callable(self, "_on_area_input_event"))

func _on_area_input_event(_viewport, event, _shape_idx):
	if InputLock.input_locked:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("exit_button_clicked")
