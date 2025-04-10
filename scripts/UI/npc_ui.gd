extends Node2D

var enemy: Enemy
@onready var health_label = $MetalPanel/Health
@onready var hearts_node = $MetalPanel/Hearts
@export var npcIcon: Sprite2D
@export var hearts: Node2D

func initialize_for_clinic():
	health_label.visible = false
	hearts_node.visible = false
	npcIcon.frame = 1

func initialize_for_enemy():
	health_label.visible = true
	hearts_node.visible = true
	npcIcon.frame = 0

func _on_enemy_health_changed(new_max_health: int, new_health: int):
	health_label.text = str(new_health)
	hearts_node.max_health = new_max_health
	hearts_node.current_health = new_health
	if new_max_health > 0:
		hearts_node.update_hearts()
