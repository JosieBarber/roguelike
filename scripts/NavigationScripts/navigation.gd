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

var offshoot_toggle: bool = true  # Tracks whether the next offshoot is on the top or bottom

func _ready():
	_initialize_graph(20, 1, 3)  # Example: 20 intermediate nodes, 1 boss, 2 clinics
	Events.connect("_navigation_node_selected", Callable(self, "_on_node_selected"))

func _initialize_graph(intermediate_nodes: int, boss_count: int, clinic_count: int):
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# Adjust area size based on the number of intermediate nodes (horizontal expansion only)
	var area_width = 200 + intermediate_nodes * 20
	var area_height = 90  # Fixed vertical space

	# Create starting node
	var start_node = _create_navigation_node(Vector2(0, area_height / 2), NodeType.BLANK)
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

	# Ensure the total number of nodes matches the expected count (22 in this case)
	while graph.size() < intermediate_nodes + 2:  # +2 for start and end nodes
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

	# Generate clinic nodes evenly spaced and ensure they are at least 2 nodes apart
	var graph_nodes = graph.keys()
	var clinic_spacing = graph_nodes.size() / (clinic_count + 1)
	var selected_clinic_nodes = []

	for i in range(clinic_count):
		var target_index = int((i + 1) * clinic_spacing)
		if target_index >= graph_nodes.size():
			target_index = graph_nodes.size() - 1

		var target_node = graph_nodes[target_index]

		# Ensure the selected node is at least 2 nodes apart from other clinics
		var is_valid = true
		for clinic_node in selected_clinic_nodes:
			if target_node.position.distance_to(clinic_node.position) < node_distance * 2:
				is_valid = false
				break

		if is_valid:
			target_node.node_type = NodeType.CLINIC
			target_node._update_visual()
			selected_clinic_nodes.append(target_node)

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

	# Ensure no nodes are only connected to the end node
	for node in graph.keys():
		if graph[node].size() == 1 and graph[node][0] == end_node:
			var closest_node = _find_closest_node_to(node)
			if closest_node:
				graph[node].append(closest_node)
				graph[closest_node].append(node)

	# Ensure disconnected groups are connected to the main structure
	_connect_disconnected_groups()

	$Map/PlayerIcon.position = current_node.position
	_update_adjacent_nodes()
	_draw_paths()

func _convert_lonely_combat_nodes_to_bosses():
	for node in graph.keys():
		if node.node_type == NodeType.COMBAT and graph[node].size() == 1:
			print("Converting lonely combat node to boss")
			node.node_type = NodeType.BOSS  # Directly update the node_type property
			nodes[node] = false  # Ensure the node is not marked as visited
			node._update_visual()  # Update visuals after changing the type

func _ensure_boss_navigation(start_node: Node2D, end_node: Node2D):
	for boss_node in graph.keys():
		if boss_node.node_type == NodeType.BOSS and boss_node != start_node and boss_node != end_node:
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
	var attempts = 0
	while not _has_path_to_end(start_node, end_node) and attempts < 100:  # Limit iterations
		var closest_pair = _find_closest_unconnected_nodes()
		if closest_pair:
			var node_a = closest_pair[0]
			var node_b = closest_pair[1]
			graph[node_a].append(node_b)
			graph[node_b].append(node_a)
		else:
			print("No unconnected nodes found to ensure a complete path")
			break
		attempts += 1
	if attempts >= 100:
		print("Failed to ensure a complete path after 100 attempts")

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
	var attempts = 0
	while attempts < 100:  # Limit the number of attempts to prevent infinite loops
		var x = rng.randf_range(current_node.position.x, area_width)  # Ensure x >= starting node's x
		var y = rng.randf_range(0, area_height)
		var position = Vector2(x, y)
		if not _is_overlapping(position):
			return position
		attempts += 1

	# If no valid position is found, create a one-off branch further out vertically
	var fallback_x = rng.randf_range(current_node.position.x, area_width)
	var fallback_y = area_height + 30 if offshoot_toggle else -30  # Alternate top and bottom
	offshoot_toggle = not offshoot_toggle  # Toggle for the next offshoot
	return Vector2(fallback_x, fallback_y)

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
	var node_display = preload("res://scenes/assets/NodeDisplay.tscn").instantiate()
	node_display.position = position
	node_display.node_type = node_type  # Directly set the node_type property
	nodes_container.add_child(node_display)
	node_display._update_visual()  # Ensure the node is drawn with the correct visuals
	return node_display

func _on_node_selected(node_display: Node2D):
	if node_display in adjacent_nodes:
		current_node = node_display
		$Map/PlayerIcon.position = current_node.position
		_update_adjacent_nodes()
		if not nodes.get(node_display, false):  # Use `get` to safely access dictionary values
			var node_type = node_display.node_type  # Directly access the node_type property
			match node_type:
				NodeType.COMBAT, NodeType.CLINIC, NodeType.BOSS:
					_transition_to_encounter(node_display)
					nodes[node_display] = true  # Mark as visited only for non-blank nodes
				NodeType.BLANK:
					nodes[node_display] = false
			node_display.mark_as_visited()
			node_display._update_visual()  # Ensure the node's visuals are updated

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
	var node_type = node.node_type
	match node_type:
		NodeType.COMBAT:
			print("Transitioning to combat")
			var combat_scene = load("res://scenes/screens/Combat/Combat.tscn").instantiate()
			get_parent().add_child(combat_scene)
			player.copy_deck()
		NodeType.CLINIC:
			print("Transitioning to clinic")
			var clinic_scene = load("res://scenes/screens/Clinic/Clinic.tscn").instantiate()
			get_parent().add_child(clinic_scene)
		NodeType.BOSS:
			print("Transitioning to boss")
			# Add boss-specific logic here
	self.visible = false

func _connect_disconnected_groups():
	var visited = []
	var to_visit = [current_node]

	# Perform a breadth-first search to find all connected nodes
	while to_visit.size() > 0:
		var current = to_visit.pop_front()
		if current not in visited:
			visited.append(current)
			to_visit += graph.get(current, [])

	# Find nodes not in the main connected group
	var disconnected_nodes = []
	for node in graph.keys():
		if node not in visited:
			disconnected_nodes.append(node)

	for node in disconnected_nodes:
		var closest_node = null
		var min_distance = INF

		# Look for the closest node further to the left
		for connected_node in visited:
			if connected_node.position.x < node.position.x:
				var distance = node.position.distance_to(connected_node.position)
				if distance < min_distance:
					min_distance = distance
					closest_node = connected_node

		# Connect the node to the closest valid node or create a one-off branch
		if closest_node:
			graph[node].append(closest_node)
			graph[closest_node].append(node)
		else:
			# Create a one-off branch by connecting to a random visited node
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var branch_node = visited[rng.randi_range(0, visited.size() - 1)]
			graph[node].append(branch_node)
			graph[branch_node].append(node)

func get_node_at_screen_position(screen_position: Vector2) -> Node2D:
	# Iterate through all nodes in the nodes_container to find one at the given position
	for node in nodes_container.get_children():
		
		
		if node is Node2D and node.has_node("Area2D") and node.get_node("Area2D").has_node("CollisionShape2D"):
			#print(node.name)
			#print("Nodes in container")
			print(node.position)
			var collision_shape = node.get_node("Area2D").get_node("CollisionShape2D") as CollisionShape2D
			if collision_shape and collision_shape.shape:
				var shape = collision_shape.shape
				var transform = collision_shape.get_global_transform()
				if shape is CircleShape2D:
					#print("node has shape of circle")
					var center = transform.origin
					var radius = shape.radius
					#print(center.distance_to(screen_position))
					#print(screen_position)
					if center.distance_to(screen_position) <= radius:
						return node
	print("No Node Found")
	return null
