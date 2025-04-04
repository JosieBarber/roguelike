extends CanvasLayer
class_name PixelPerfectUiLayer

@onready var sub_viewport: SubViewport = $SubViewport

func _ready() -> void:
	var pixel_perfect_things = get_tree().get_nodes_in_group("PP")
	
	for thing in pixel_perfect_things:
		if thing.get_parent().is_in_group("Ui"):
			print("Reparenting:", thing.name)  # Debug statement
			thing.call_deferred("reparent", sub_viewport, true)
		else:
			print("Skipping:", thing.name)  # Debug statement
