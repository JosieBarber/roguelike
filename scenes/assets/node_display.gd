extends Node2D

@export var node_type: int
@export var visited_icon: Texture = load("res://assets/Visited Icon.png")
@export var combat_icon: Texture = load("res://assets/Combat Icon.png")
@export var clinic_icon: Texture = load("res://assets/Clinic Icon.png")
@export var blank_icon: Texture = load("res://assets/Empty Icon.png")
@export var boss_icon: Texture = load("res://assets/Shop Icon.png")

var is_visited: bool = false

enum NodeType { COMBAT, CLINIC, BLANK, BOSS }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_visual()

# Updates the node's visual based on its type and visited state.
func _update_visual():
	var sprite = $Sprite2D
	if is_visited:
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
				sprite.texture = boss_icon

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
		if event is InputEventMouseButton and event.pressed:
			Events._navigation_node_selected.emit(self)
			print("Node selected in node display")
		

func mark_as_visited():
	is_visited = true
	_update_visual()
