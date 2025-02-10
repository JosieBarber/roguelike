extends Node2D

class_name NodeVisual

var color: Color
var radius: float

func _init(color: Color, radius: float):
	self.color = color
	self.radius = radius

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
