extends Node2D

class_name Navigation

var player: Player
var current_node: Node2D
var combat_icon: Texture
var clinic_icon: Texture
var shop_icon: Texture
var visited_icon: Texture
var nodes: Dictionary = {}

enum NodeType { COMBAT, CLINIC, SHOP }

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
	# Initialize the navigation map and player position
	_initialize_map()

func _initialize_map():
	# Create nodes and paths for navigation
	var node1 = _create_navigation_node(Vector2(20, 20), NodeType.COMBAT)
	var node2 = _create_navigation_node(Vector2(60, 20), NodeType.CLINIC)
	var node3 = _create_navigation_node(Vector2(100, 20), NodeType.SHOP)
	var node4 = _create_navigation_node(Vector2(100, 60), NodeType.SHOP)

	current_node = node1
	$PlayerIcon.position = current_node.position

func _create_navigation_node(position: Vector2, node_type: int) -> Node2D:
	var node = Node2D.new()
	node.position = position
	node.set_meta("type", node_type)
	$Nodes.add_child(node)
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
		if not nodes[node]:
			print("Node selected: ", node)
			_on_node_selected(node)

func _on_node_selected(node: Node2D):
	current_node = node
	nodes[node] = true
	_draw_node_icon(node)  # Update the node icon to visited
	$PlayerIcon.position = current_node.position
	_transition_to_encounter(node)

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
