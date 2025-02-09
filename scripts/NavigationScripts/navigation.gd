extends Node2D

class_name Navigation

var player: Player
var current_node: Node2D
var combat_icon: Texture

func _ready():
	if get_parent().get_node("Player"):
		player = get_parent().get_node("Player")
	if not player:
		player = Player.new()
		get_parent().call_deferred("add_child", player)
		player.initialize("JosiePosie", 10)
		player._create_test_deck()
	# Load the combat icon texture
	combat_icon = load("res://assets/Combat Icon.png")
	# Initialize the navigation map and player position
	_initialize_map()

func _initialize_map():
	# Create nodes and paths for navigation
	# This is a placeholder, you should create your own map logic
	var node1 = _create_navigation_node(Vector2(100, 100))
	var node2 = _create_navigation_node(Vector2(300, 100))
	
	current_node = node1
	$PlayerIcon.position = current_node.position

func _create_navigation_node(position: Vector2) -> Node2D:
	var node = Node2D.new()
	node.position = position
	$Nodes.add_child(node)
	_draw_node_icon(node)
	return node

func _draw_node_icon(node: Node2D):
	var area = Area2D.new()
	var sprite = Sprite2D.new()
	sprite.texture = combat_icon
	sprite.position = Vector2.ZERO
	sprite.scale = Vector2(0.1, 0.1)  # Scale down the sprite
	area.add_child(sprite)
	
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = 20  # Adjust to match the scaled sprite size
	area.add_child(collision_shape)
	
	area.position = Vector2.ZERO
	area.connect("input_event", Callable(self, "_on_icon_input_event").bind(node))
	node.add_child(area)

func _on_icon_input_event(viewport, event, shape_idx, node):
	if event is InputEventMouseButton and event.pressed:
		print("Node selected: ", node)
		_on_node_selected(node)

func _on_node_selected(node: Node2D):
	current_node = node
	$PlayerIcon.position = current_node.position
	# Transition to the next encounter (e.g., combat or event)
	_transition_to_encounter()

func _transition_to_encounter():
	# Placeholder for transitioning to the next encounter
	var combat_scene = get_parent().get_node("Combat")
	combat_scene.visible = true
	self.visible = false
	combat_scene._on_start_combat_pressed()
