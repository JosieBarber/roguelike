extends Node2D

signal ready_button_clicked()
@onready var sprite = $Sprite2D

var space_bar_pressed: bool = false

func _ready():
	var area = $Area2D
	space_bar_pressed = false
	area.connect("input_event", Callable(self, "_on_area_input_event"))

func _on_area_input_event(_viewport, event, _shape_idx):
	if InputLock.input_locked:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			space_bar_pressed = true
		if space_bar_pressed and not event.pressed:
			space_bar_pressed = false
			emit_signal("ready_button_clicked")

func _input(event):
	if InputLock.input_locked:
		return
	if event is InputEventKey and event.keycode == KEY_SPACE and self.visible:
		if event.pressed:
			space_bar_pressed = true
		if space_bar_pressed and not event.pressed:
			space_bar_pressed = false
			emit_signal("ready_button_clicked")
			
func _process(_delta):
	if space_bar_pressed:
		sprite.frame = 1
	else:
		sprite.frame = 0
		

	
