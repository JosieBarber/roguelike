extends Node2D

var player: Player

var max_health: int 
var health: int

func _ready():
	player = get_parent().get_parent().get_node("Player")
	max_health = player.max_health
	health = player.health
	player.connect("player_health_changed", Callable(self, "_on_player_health_changed"))

func _on_player_health_changed(new_max_health: int, new_health: int):
	max_health = new_max_health
	health = new_health
	update_hearts()

func update_hearts():
	var hearts_node = get_node("MetalPanel").get_node("Hearts")
	hearts_node.max_health = max_health
	hearts_node.current_health = health
	hearts_node.update_hearts()
