extends Node3D

@onready var raycast = $Node3D/RayCast3D
@onready var sub_viewport = $Node3D/SubViewport

func _process(delta):
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return

	# Update the raycast's origin and target position based on the mouse position
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = camera.project_ray_origin(mouse_pos) + camera.project_ray_normal(mouse_pos) * 1000
	raycast.global_transform.origin = from
	raycast.target_position = to  # Set the target position for the raycast

	# Check for collisions on mouse click
	if Input.is_action_just_pressed("click"):
		print("Mouse clicked at:", mouse_pos)
		raycast.force_raycast_update()
		if raycast.is_colliding():
			print("Raycast is colliding")
			var collision_point = raycast.get_collision_point()
			var collider = raycast.get_collider()
			if collider and collider is Area3D:
				print("Collision at x:", collision_point.x, "y:", collision_point.y)

	# Check for collisions with navigation nodes
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("navigation_node"):
			_handle_node_interaction(collider)

func _handle_node_interaction(node):
	print("Node hit:", node.name)
	# Emit a signal or directly call a function to handle the interaction
	Events._navigation_node_selected.emit(node)
