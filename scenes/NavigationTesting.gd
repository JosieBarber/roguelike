extends Node3D

@onready var raycast = $Node3D/RayCast3D
@onready var sub_viewport = $Node3D/SubViewport
@onready var map_area = $Node3D/Area3D/CollisionShape3D

@onready var navigation = $Node3D/SubViewport/Navigation

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	player.initialize("TestPLayer", 20)


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
				print("Area3D hit:", collider.name)
				print(area_location_to_viewport_location(collision_point))
				adjust_collision_location(collision_point)
				var adjusted_collision_point = adjust_collision_location(collision_point)
				var viewport_collision_point = area_location_to_viewport_location(adjusted_collision_point)
				print("Viewport collision at:", viewport_collision_point)
				_handle_node_interaction(navigation.get_node_at_screen_position(viewport_collision_point))


	# Check for collisions with navigation nodes
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("navigation_node"):
			_handle_node_interaction(collider)

func _handle_node_interaction(node):
	if node:
		print("Node hit:", node.name)
		Events._navigation_node_selected.emit(node)

func adjust_collision_location(collision_point) -> Vector2:
	var map_area_2D: Vector2 = Vector2(map_area.shape.size.x, map_area.shape.size.y)
	var collision_point_2D: Vector2 = Vector2(collision_point.x, collision_point.y)
	var adjusted_collision_point: Vector2 = Vector2(collision_point_2D.x + (map_area_2D.x / 2), abs(collision_point_2D.y - (map_area_2D.y / 2)))


	return adjusted_collision_point


func area_location_to_viewport_location(collision_point) -> Vector2:
	var map_area_2D: Vector2 = Vector2(map_area.shape.size.x, map_area.shape.size.y)
	var collision_point_2D: Vector2 = Vector2(collision_point.x, collision_point.y)
	var ratio: float = float(map_area_2D.x / sub_viewport.size.x)
	return Vector2(collision_point_2D.x / ratio, (collision_point.y / ratio))
