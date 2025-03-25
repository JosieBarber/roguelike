extends Node2D

class_name Navigation

@onready var player: Player = get_tree().get_first_node_in_group("player")

@onready var combat_icon: Texture = load("res://assets/Combat Icon.png")
@onready var clinic_icon: Texture = load("res://assets/Clinic Icon.png")
@onready var shop_icon: Texture = load("res://assets/Shop Icon.png")
@onready var visited_icon: Texture = load("res://assets/Visited Icon.png")
@onready var blank_icon: Texture = load("res://assets/Empty Icon.png")
@onready var nodes_container: Node2D = $Map/Nodes

var current_node: Node2D
var graph: Dictionary = {}  # Graph structure: {Node2D: [connected Node2D]}
var nodes: Dictionary = {}  # Tracks visited nodes: {Node2D: bool}
var adjacent_nodes: Array = []

enum NodeType { COMBAT, CLINIC, BLANK, BOSS }

# Configurable values
var node_distance: float = 45.0  # Minimum distance between nodes
var combat_proportion: float = 0.7  # Proportion of combat nodes

func _ready():
	_initialize_graph(20, 1, 2)  # Example: 20 intermediate nodes, 1 boss, 2 clinics

func _initialize_graph(intermediate_nodes: int, boss_count: int, clinic_count: int):
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# Adjust area size based on the number of intermediate nodes (horizontal expansion only)
	var area_width = 200 + intermediate_nodes * 20
	var area_height = 90  # Fixed vertical space

	# Create starting node
	var start_node = _create_navigation_node(Vector2(20, area_height / 2), NodeType.BLANK)
	current_node = start_node
	graph[start_node] = []  # Initialize graph with the starting node

	# Generate boss nodes evenly spaced
	var boss_spacing = area_width / (boss_count + 1)
	var boss_nodes = []
	for i in range(boss_count):
		var boss_position = Vector2((i + 1) * boss_spacing, area_height / 2)
		var boss_node = _create_navigation_node(boss_position, NodeType.BOSS)
		graph[boss_node] = []  # Boss nodes are not connected to each other
		boss_nodes.append(boss_node)

	# Create ending node (always a boss)
	var end_position = Vector2(area_width, area_height / 2)
	var end_node = _create_navigation_node(end_position, NodeType.BOSS)
	graph[end_node] = []  # Ending boss node is also isolated

	# Generate intermediate nodes
	var combat_nodes = int(intermediate_nodes * combat_proportion)
	var blank_nodes = intermediate_nodes - combat_nodes
	var intermediate_nodes_list = []

	while graph.size() < intermediate_nodes + boss_count + clinic_count + 2:  # +2 for start and end nodes
		var position = _get_valid_position(rng, area_width, area_height)
		var node_type = NodeType.BLANK
		if combat_nodes > 0:
			node_type = NodeType.COMBAT
			combat_nodes -= 1
		elif blank_nodes > 0:
			node_type = NodeType.BLANK
			blank_nodes -= 1

		var new_node = _create_navigation_node(position, node_type)
		graph[new_node] = []
		intermediate_nodes_list.append(new_node)

	# Generate clinic nodes
	var graph_nodes = graph.keys()
	var clinic_spacing = graph_nodes.size() / (clinic_count + 1)
	for i in range(clinic_count):
		var target_index = int((i + 1) * clinic_spacing)
		if target_index >= graph_nodes.size():
			target_index = graph_nodes.size() - 1
		var target_node = graph_nodes[target_index]
		if target_node.get_meta("type") == NodeType.BLANK:  # Only convert blank nodes to clinics
			target_node.set_meta("type", NodeType.CLINIC)
			_draw_node_icon(target_node)

	# Ensure a guaranteed path from start to end
	_ensure_complete_path(start_node, end_node)

	# Connect remaining intermediate nodes randomly
	for node in intermediate_nodes_list:
		_connect_to_existing_nodes(node, rng)

	# Ensure combat nodes with one connection are converted to bosses
	_convert_lonely_combat_nodes_to_bosses()

	# Sever random connections
	_sever_random_connections(0.08, end_node)  # 8% of connections

	# Ensure regular bosses must be navigated through
	_ensure_boss_navigation(start_node, end_node)

	$Map/PlayerIcon.position = current_node.position
	_update_adjacent_nodes()
	_draw_paths()

func _convert_lonely_combat_nodes_to_bosses():
	for node in graph.keys():
		if node.get_meta("type") == NodeType.COMBAT and graph[node].size() == 1:
			print("Converting lonely combat node to boss")
			node.set_meta("type", NodeType.BOSS)
			nodes[node] = false  # Ensure the node is not marked as visited
			_draw_node_icon(node)

func _ensure_boss_navigation(start_node: Node2D, end_node: Node2D):
	for boss_node in graph.keys():
		if boss_node.get_meta("type") == NodeType.BOSS and boss_node != start_node and boss_node != end_node:
			if not _is_boss_on_path(start_node, end_node, boss_node):
				# Force a connection to ensure the boss is on the path
				var closest_node = _find_closest_node_to(boss_node)
				if closest_node:
					graph[boss_node].append(closest_node)
					graph[closest_node].append(boss_node)

func _is_boss_on_path(start_node: Node2D, end_node: Node2D, boss_node: Node2D) -> bool:
	var visited = []
	var to_visit = [start_node]

	while to_visit.size() > 0:
		var current = to_visit.pop_front()
		if current == end_node:
			return boss_node in visited
		if current not in visited:
			visited.append(current)
			to_visit += graph[current]
	return false

func _find_closest_node_to(target_node: Node2D) -> Node2D:
	var closest_node = null
	var min_distance = INF

	for node in graph.keys():
		if node != target_node and target_node not in graph[node]:
			var distance = node.position.distance_to(target_node.position)
			if distance < min_distance:
				min_distance = distance
				closest_node = node

	return closest_node

func _sever_random_connections(percentage: float, end_node: Node2D):
	var all_connections = []
	for node in graph.keys():
		var connections = graph.get(node, [])  # Use `get` to safely access dictionary values
		for connected_node in connections:
			if [connected_node, node] not in all_connections:  # Avoid duplicate pairs
				all_connections.append([node, connected_node])

	var connections_to_sever = int(all_connections.size() * percentage)
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	while connections_to_sever > 0 and all_connections.size() > 0:
		var connection = all_connections[rng.randi_range(0, all_connections.size() - 1)]
		var node_a = connection[0]
		var node_b = connection[1]

		# Temporarily sever the connection
		graph[node_a].erase(node_b)
		graph[node_b].erase(node_a)

		# Check if the graph is still connected and no node is isolated
		if _has_path_to_end(current_node, end_node) and graph[node_a].size() > 0 and graph[node_b].size() > 0:
			connections_to_sever -= 1  # Keep the connection severed
		else:
			# Restore the connection if it breaks the graph
			graph[node_a].append(node_b)
			graph[node_b].append(node_a)

		all_connections.erase(connection)

func _ensure_complete_path(start_node: Node2D, end_node: Node2D):
	while not _has_path_to_end(start_node, end_node):
		var closest_pair = _find_closest_unconnected_nodes()
		if closest_pair:
			var node_a = closest_pair[0]
			var node_b = closest_pair[1]
			graph[node_a].append(node_b)
			graph[node_b].append(node_a)

func _has_path_to_end(start_node: Node2D, end_node: Node2D) -> bool:
	var visited = []
	var to_visit = [start_node]

	while to_visit.size() > 0:
		var current = to_visit.pop_front()
		if current == end_node:
			return true
		if current not in visited:
			visited.append(current)
			to_visit += graph[current]
	return false

func _find_closest_unconnected_nodes() -> Array:
	var unconnected_nodes = graph.keys()
	var closest_pair = null
	var min_distance = INF

	for i in range(unconnected_nodes.size()):
		for j in range(i + 1, unconnected_nodes.size()):
			var node_a = unconnected_nodes[i]
			var node_b = unconnected_nodes[j]
			if node_b not in graph[node_a]:  # Check if not already connected
				var distance = node_a.position.distance_to(node_b.position)
				if distance < min_distance:
					min_distance = distance
					closest_pair = [node_a, node_b]

	return closest_pair

func _get_valid_position(rng: RandomNumberGenerator, area_width: float, area_height: float) -> Vector2:
	while true:
		var x = rng.randf_range(0, area_width)
		var y = rng.randf_range(0, area_height)
		var position = Vector2(x, y)
		if not _is_overlapping(position):
			return position
	return Vector2.ZERO  # Fallback return value

func _is_overlapping(position: Vector2) -> bool:
	for node in graph.keys():
		if node.position.distance_to(position) < node_distance:
			return true
	return false

func _connect_to_existing_nodes(new_node: Node2D, rng: RandomNumberGenerator):
	var max_connections = rng.randi_range(1, 3)  # Randomize the number of connections
	var potential_nodes = graph.keys()
	potential_nodes.shuffle()

	for node in potential_nodes:
		if graph[new_node].size() >= max_connections:
			break
		if node != new_node and node.position.distance_to(new_node.position) <= 60:
			graph[new_node].append(node)
			graph[node].append(new_node)

func _create_navigation_node(position: Vector2, node_type: int) -> Node2D:
	var node = Node2D.new()
	node.position = position
	node.set_meta("type", node_type)
	nodes_container.add_child(node)
	_draw_node_icon(node)
	return node

func _draw_node_icon(node: Node2D):
	var area = Area2D.new()
	var sprite = Sprite2D.new()
	var node_type = node.get_meta("type")
	if node_type != NodeType.BLANK and (node in graph and graph[node].size() > 0):
		sprite.texture = visited_icon
	else:
		match node_type:
			NodeType.COMBAT:
				sprite.texture = combat_icon
			NodeType.CLINIC:
				sprite.texture = clinic_icon
			NodeType.BLANK:
				sprite.texture = blank_icon
			NodeType.BOSS:
				sprite.texture = shop_icon  # Placeholder for boss icon
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
			_on_node_selected(node)

func _on_node_selected(node: Node2D):
	current_node = node
	$Map/PlayerIcon.position = current_node.position
	_update_adjacent_nodes()
	if not nodes.get(node, false):  # Use `get` to safely access dictionary values
		var node_type = node.get_meta("type")
		match node_type:
			NodeType.COMBAT, NodeType.CLINIC, NodeType.BOSS:
				_transition_to_encounter(node)
				nodes[node] = true  # Mark as visited only for non-blank nodes
			NodeType.BLANK:
				nodes[node] = false 
				pass
	_draw_node_icon(node)

func _update_adjacent_nodes():
	adjacent_nodes = graph.get(current_node, [])  # Use `get` to safely access dictionary values

func _draw_paths():
	for node in graph.keys():
		var connections = graph.get(node, [])  # Use `get` to safely access dictionary values
		for connected_node in connections:
			_draw_line_between_nodes(node, connected_node)

func _draw_line_between_nodes(node1: Node2D, node2: Node2D):
	var line = Line2D.new()
	line.width = 1
	line.default_color = Color(1, 1, 1)
	line.add_point(node1.position)
	line.add_point(node2.position)
	nodes_container.add_child(line)

func _transition_to_encounter(node: Node2D):
	var node_type = node.get_meta("type")
	match node_type:
		NodeType.COMBAT:
			print("Transitioning to combat")
			var combat_scene = load("res://scenes/Screens/Combat/Combat.tscn").instantiate()
			get_parent().add_child(combat_scene)
			player.copy_deck()
		NodeType.CLINIC:
			print("Transitioning to clinic")
			var clinic_scene = load("res://scenes/Screens/Clinic/Clinic.tscn").instantiate()
			get_parent().add_child(clinic_scene)
		NodeType.BOSS:
			print("Transitioning to boss")
			# Add boss-specific logic here
	self.visible = false
