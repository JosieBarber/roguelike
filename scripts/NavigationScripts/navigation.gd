extends Node2D

# Import the AreaNode class
const AreaNode = preload("res://scripts/NavigationScripts/area_node.gd")

var graph = []
var icons = {
	AreaNode.NodeType.COMBAT: preload("res://assets/Combat Icon.png"),
	AreaNode.NodeType.CLINIC: preload("res://assets/Clinic Icon.png"),
	AreaNode.NodeType.ENCOUNTER: preload("res://assets/Question Mark Icon.png"),
	AreaNode.NodeType.SHOP: preload("res://assets/Shop Icon.png")
}

# Likelihoods for each node type
var node_type_likelihoods = {
	AreaNode.NodeType.COMBAT: 0.55,
	AreaNode.NodeType.CLINIC: 0.05,
	AreaNode.NodeType.ENCOUNTER: 0.4,
	AreaNode.NodeType.SHOP: 0.1
}

func _ready():
	generate_area()
	display_area()

func generate_area():
	var levels = 10
	var node_counts = [1, 2, 3, 4, 3, 4, 5, 3, 2, 1]
	var node_types = [AreaNode.NodeType.COMBAT, AreaNode.NodeType.CLINIC, AreaNode.NodeType.ENCOUNTER, AreaNode.NodeType.SHOP]

	for i in range(levels):
		var level_nodes = []
		for j in range(node_counts[i]):
			var node_type = get_random_node_type()
			if i == 0 or i == levels - 1:
				node_type = AreaNode.NodeType.COMBAT
			var node = AreaNode.new(node_type)
			node.name =  "Node_%d_%d" % [i, j]
			level_nodes.append(node)
		graph.append(level_nodes)

	# Ensure at least one COMBAT node in level 1
	if levels > 1 and graph[1].size() > 0:
		graph[1][0].type = AreaNode.NodeType.COMBAT

	connect_nodes()
	print_area()

func get_random_node_type() -> AreaNode.NodeType:
	var rand_value = randf()
	var cumulative = 0.0
	for node_type in node_type_likelihoods.keys():
		cumulative += node_type_likelihoods[node_type]
		if rand_value < cumulative:
			return node_type
	return AreaNode.NodeType.COMBAT  # Default fallback

func connect_nodes():
	for i in range(graph.size() - 1):
		for j in range(graph[i].size()):
			var node = graph[i][j]
			var next_level = graph[i + 1]
			var connections = []
			if j < next_level.size():
				connections.append(next_level[j])
			if j + 1 < next_level.size():
				connections.append(next_level[j + 1])
			if connections.size() == 0 and next_level.size() > 0:
				connections.append(next_level[0])
			node.connections = connections

	# Ensure all nodes in the next level have at least one parent
	for i in range(graph.size() - 1):
		var next_level = graph[i + 1]
		for j in range(next_level.size()):
			var has_parent = false
			for node in graph[i]:
				if next_level[j] in node.connections:
					has_parent = true
					break
			if not has_parent:
				graph[i][randi() % graph[i].size()].connections.append(next_level[j])

	# Ensure all nodes in the current level have at least one child
	for i in range(graph.size() - 1):
		for node in graph[i]:
			if node.connections.size() == 0:
				node.connections.append(graph[i + 1][randi() % graph[i + 1].size()])

func print_area():
	for i in range(graph.size()):
		print("Level %d:" % i)
		for node in graph[i]:
			print("%s: %s" % [node.name, node.to_string()])
			for connection in node.connections:
				print("  -> %s" % connection.name)
			print("")

func display_area():
	var y_offset = 50
	var x_spacing = 100
	var y_spacing = 100

	for i in range(graph.size()):
		var x_offset = (get_viewport().size.x - (graph[i].size() * x_spacing)) / 2
		for j in range(graph[i].size()):
			var node = graph[i][j]
			var icon = Sprite2D.new()
			icon.texture = icons[node.type]
			icon.scale = Vector2(0.1, 0.1)
			icon.position = Vector2(x_offset + j * x_spacing, y_offset + i * y_spacing)
			add_child(icon)

			var label = Label.new()
			label.text = node.name
			label.position = icon.position + Vector2(0, 25)
			label.scale = Vector2(0.5, 0.5)
			add_child(label)
