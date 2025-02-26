extends Node2D

class_name Navigation

var player: Player
var current_node: Node2D
var combat_icon: Texture
var clinic_icon: Texture
var shop_icon: Texture
var visited_icon: Texture
var nodes: Dictionary = {}
var adjacent_nodes: Array = []
var nodes_container: Node2D

enum NodeType { COMBAT, CLINIC, SHOP, BLANK }

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
	# Get the Nodes container
	nodes_container = $Map/Nodes
	# Initialize the navigation map and player position
	_initialize_map()

func _initialize_map():
	# Create nodes and paths for navigation
	var node1 = _create_navigation_node(Vector2(20, 20), NodeType.BLANK)
	var node2 = _create_navigation_node(Vector2(40, 55), NodeType.COMBAT)
	var node3 = _create_navigation_node(Vector2(60, 10), NodeType.CLINIC)
	var node4 = _create_navigation_node(Vector2(100, 20), NodeType.SHOP)
	var node5 = _create_navigation_node(Vector2(100, 60), NodeType.COMBAT)

	current_node = node1
	$Map/PlayerIcon.position = current_node.position
	_update_adjacent_nodes()
	_draw_paths()

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
	if nodes[node]:
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
				return 
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
	if not nodes[node]:
		_transition_to_encounter(node)
	nodes[node] = true
	_draw_node_icon(node)  # Update the node icon to visited

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
