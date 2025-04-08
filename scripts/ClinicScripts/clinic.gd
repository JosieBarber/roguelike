extends Node2D

class_name Clinic

#@onready var npc_ui = navigation_scene.get_parent().get_node("Ui").get_node("EnemyUi")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var navigation = get_tree().get_first_node_in_group("navigation")

@onready var health_shop_scene: PackedScene
@onready var health_shop_instance: Node2D
@onready var card_shop_instance = get_node("CardShop")
@onready var clinic_menu = $ClinicMenu


func _ready():
	player.prepare_deck()
	_transition_to_clinic()

func _transition_to_clinic():
	Events._navigation_focus.emit(false, false)
	navigation.visible = false
	self.visible = true

func _transition_to_health_shop():
	health_shop_scene = preload("res://scenes/Screens/Clinic/HealthShop.tscn")
	clinic_menu.visible = false
	player.prepare_deck()
	health_shop_instance = health_shop_scene.instantiate()
	self.add_child(health_shop_instance)

func _transition_from_health_shop():
	InputLock._lock_scene_input()
	health_shop_instance.queue_free()
	clinic_menu.visible = true

func _transition_to_card_shop():
	InputLock._lock_scene_input()
	card_shop_instance.visible = true
	player.prepare_deck()
	card_shop_instance._display_player_deck()
	clinic_menu.visible = false
	
func _transition_from_card_shop():
	InputLock._lock_scene_input()
	card_shop_instance.visible = false
	clinic_menu.visible = true
	
func _transition_to_navigation():
	InputLock._lock_scene_input()
	navigation.visible = true
	Events._navigation_focus.emit(true, true)
	self.queue_free()
