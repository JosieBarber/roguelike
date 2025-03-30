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

			# Check for collisions in the 2D space of the SubViewport
			_check_collision_in_subviewport(collision_point)

	# Check for collisions with navigation nodes
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("navigation_node"):
			_handle_node_interaction(collider)

func _handle_node_interaction(node):
	print("Node hit:", node.name)
	# Emit a signal or directly call a function to handle the interaction
	Events._navigation_node_selected.emit(node)

func _check_collision_in_subviewport(collision_point_3d):
	# Convert the 3D collision point to 2D using the SubViewport's Camera2D
	var sub_camera = sub_viewport.get_node("Camera2D")  # Ensure a Camera2D exists in the SubViewport
	if not sub_camera:
		print("No Camera2D found in SubViewport")
		return

	# Transform the 3D collision point into the Camera2D's local space
	var global_transform = sub_camera.get_global_transform()
	var collision_point_2d = global_transform.affine_inverse().basis_xform_inv(Vector2(collision_point_3d.x, collision_point_3d.y))

	# Convert the collision point from meters to pixels
	var collision_point_pixels = collision_point_2d * sub_camera.zoom
	print("Projected 2D collision point in pixels:", collision_point_pixels)

	# Use the Navigation script's method to find a node at the screen position
	var navigation = sub_viewport.get_node("Navigation")  # Adjust path if necessary
	if navigation and navigation.has_method("get_node_at_screen_position"):
		var area2d = navigation.get_node_at_screen_position(collision_point_pixels)
		if area2d:
			print("Collision with Area2D:", area2d.name)
			_handle_area2d_interaction(area2d)

func _handle_area2d_interaction(area2d):
	print("Area2D hit:", area2d.name)
	# Handle interaction with the Area2D
	# Example: Emit a signal or call a function
