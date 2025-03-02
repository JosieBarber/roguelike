extends Node2D

class_name Navigation

var player: Player
var current_node: Node2D
var combat_icon: Texture
var clinic_icon: Texture
var shop_icon: Texture
var visited_icon: Texture
var blank_icon: Texture  # Add blank icon
var nodes: Dictionary = {}
var adjacent_nodes: Array = []
var nodes_container: Node2D

enum NodeType { COMBAT, CLINIC, SHOP, BLANK }

# Configurable values
var node_distance: float = 35.0  # Minimum distance between nodes
var combat_proportion: float = 0.8  # Proportion of combat nodes

func _ready():
	if get_parent().get_node("Player"):
		player = get_parent().get_node("Player")
	if not player:
		player = Player.new()
		get_parent().call_deferred("add_child", player)
		player.initialize("JosiePosie", 10)
		player._create_test_deck()
	# Load the icons
	combat_icon = load("res://assets/Combat Icon.png")
	clinic_icon = load("res://assets/Clinic Icon.png")
	shop_icon = load("res://assets/Shop Icon.png")
	visited_icon = load("res://assets/Visited Icon.png")
	blank_icon = load("res://assets/Empty Icon.png")
	# Get the Nodes container
	nodes_container = $Map/Nodes
	# Initialize the navigation map and player position
	_initialize_map()

func _initialize_map():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# Create starting node
	var start_node = _create_navigation_node(Vector2(20, 20), NodeType.BLANK)
	current_node = start_node
	nodes[start_node] = true  # Mark the starting node as visited


	var created_nodes = 0
	var total_nodes = 6
	var combat_nodes = int(total_nodes * combat_proportion)
	var blank_nodes = total_nodes - combat_nodes

	var has_clinic = false
	var has_shop = false

	while created_nodes < total_nodes:
		var x = rng.randf_range(0, 200)
		var y = rng.randf_range(0, 70)
		var position = Vector2(x, y)
		if not _is_overlapping(position):
			var node_type = NodeType.BLANK
			if combat_nodes > 0:
				node_type = NodeType.COMBAT
				combat_nodes -= 1
			elif blank_nodes > 0 and not _is_adjacent_to_blank(position):
				node_type = NodeType.BLANK
				blank_nodes -= 1

			_create_navigation_node(position, node_type)
			created_nodes += 1

	# Ensure at least one shop and one clinic if not already created
	if not has_shop:
		_create_navigation_node(_get_valid_position(rng), NodeType.SHOP)
	if not has_clinic:
		_create_navigation_node(_get_valid_position(rng), NodeType.CLINIC)

	# Create ending node
	var end_node = _create_navigation_node(Vector2(220, 40), NodeType.BLANK)

	$Map/PlayerIcon.position = current_node.position
	_update_adjacent_nodes()
	_draw_paths()

func _get_valid_position(rng: RandomNumberGenerator) -> Vector2:
	while true:
		var x = rng.randf_range(0, 200)
		var y = rng.randf_range(0, 70)
		var position = Vector2(x, y)
		if not _is_overlapping(position):
			return position
	return Vector2.ZERO  # Fallback return value

func _is_adjacent_to_blank(position: Vector2) -> bool:
	for node in nodes.keys():
		if node.position.distance_to(position) < node_distance and node.get_meta("type") == NodeType.BLANK:
			return true
	return false

func _get_random_node_type(node_types: Array, probabilities: Array, rng: RandomNumberGenerator) -> int:
	var random_value = rng.randf()
	var cumulative_probability = 0.0
	for i in range(node_types.size()):
		cumulative_probability += probabilities[i]
		if random_value < cumulative_probability:
			return node_types[i]
	return node_types[0]  # Fallback to the first type

func _is_overlapping(position: Vector2) -> bool:
	for node in nodes.keys():
		if node.position.distance_to(position) < node_distance:
			return true
	return false

func _create_navigation_node(position: Vector2, node_type: int) -> Node2D:
	var node = Node2D.new()
	node.position = position
	node.set_meta("type", node_type)
	nodes_container.add_child(node)
	nodes[node] = false  # Initialize node as not visited
	_draw_node_icon(node)
	return node

func _draw_node_icon(node: Node2D):
	var area = Area2D.new()
	var sprite = Sprite2D.new()
	var node_type = node.get_meta("type")
	if nodes[node] and node_type != NodeType.BLANK:
		sprite.texture = visited_icon
	else:
		match node_type:
			NodeType.COMBAT:
				sprite.texture = combat_icon
			NodeType.CLINIC:
				sprite.texture = clinic_icon
			NodeType.SHOP:
				sprite.texture = shop_icon
			NodeType.BLANK:
				sprite.texture = blank_icon
	sprite.position = Vector2.ZERO
	sprite.scale = Vector2(0.05, 0.05)  # Scale down the sprite
	area.add_child(sprite)

	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = 10
	area.add_child(collision_shape)

	area.position = Vector2.ZERO
	area.connect("input_event", Callable(self, "_on_icon_input_event").bind(node))
	node.add_child(area)

func _on_icon_input_event(viewport, event, shape_idx, node):
	if event is InputEventMouseButton and event.pressed:
		if node in adjacent_nodes:
			print("Node selected: ", node)
			_on_node_selected(node)

func _on_node_selected(node: Node2D):
	current_node = node
	$Map/PlayerIcon.position = current_node.position
	_update_adjacent_nodes()
	if not nodes[node] and node.get_meta("type") != NodeType.BLANK:
		_transition_to_encounter(node)
		nodes[node] = true
	_draw_node_icon(node)  

func _update_adjacent_nodes():
	adjacent_nodes.clear()
	for node in nodes.keys():
		if node != current_node and node.position.distance_to(current_node.position) <= 60:
			adjacent_nodes.append(node)

func _draw_paths():
	for node in nodes.keys():
		for other_node in nodes.keys():
			if node != other_node and node.position.distance_to(other_node.position) <= 60:
				_draw_line_between_nodes(node, other_node)

func _draw_line_between_nodes(node1: Node2D, node2: Node2D):
	var line = Line2D.new()
	line.width = 1
	line.default_color = Color(1, 1, 1)
	line.add_point(node1.position)
	line.add_point(node2.position)
	nodes_container.add_child(line)

func _transition_to_encounter(node: Node2D):
	var node_type = node.get_meta("type")
	var enemy_ui = get_parent().get_node("Ui").get_node("EnemyUi")
	
	enemy_ui.visible = true
	match node_type:
		NodeType.COMBAT:
			print("Transitioning to combat")
			var combat_scene = load("res://scenes/Screens/Combat/Combat.tscn").instantiate()
			get_parent().add_child(combat_scene)
			player.copy_deck()
			combat_scene._on_start_combat_pressed()
		NodeType.CLINIC:
			print("Transitioning to clinic")
			var clinic_scene = load("res://scenes/Screens/Clinic.tscn").instantiate()
			get_parent().add_child(clinic_scene)
			clinic_scene.transition_to_clinic()
		NodeType.SHOP:
			print("Transitioning to shop")
			var shop_scene = load("res://scenes/Screens/Shop.tscn").instantiate()
			get_parent().add_child(shop_scene)
			shop_scene.transition_to_shop()
	self.visible = false
	
func _transition_to_navigation():
	var enemy_ui = get_parent().get_node("Ui").get_node("EnemyUi")
	enemy_ui.visible = false
