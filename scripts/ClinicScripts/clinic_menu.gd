extends Node2D

@onready var clinic = get_parent()

@onready var health_shop_button = $Buttons/HealthShop/Label/Area2D
@onready var card_shop_button = $Buttons/CardShop/Label/Area2D
@onready var exit_clinic_button = $Buttons/Exit/Label/Area2D

func _ready() -> void:
	# Connect signals for the labels
	health_shop_button.connect("input_event", Callable(self, "_on_health_shop_input"))
	card_shop_button.connect("input_event", Callable(self, "_on_card_shop_input"))
	exit_clinic_button.connect("input_event", Callable(self, "_on_exit_clinic_input"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Handle input for the HealthShop label
func _on_health_shop_input(_viewport, event, _shape_idx):
	if InputLock.input_locked:
		print("Input is locked, cannot do this interaction.")
		return
	if event is InputEventMouseButton and event.pressed:
		clinic._transition_to_health_shop()
		self.visible = false

func _on_card_shop_input(_viewport, event, _shape_idx):
	if InputLock.input_locked:
		print("Input is locked, cannot do this interaction.")
		return
	if event is InputEventMouseButton and event.pressed:
		
		clinic._transition_to_card_shop()
		self.visible = false
		
func _on_exit_clinic_input(_viewport, event, _shape_idx):
	if InputLock.input_locked:
		print("Input is locked, cannot do this interaction.")
		return
	if event is InputEventMouseButton and event.pressed:
		clinic.npc_ui.initialize_for_enemy()
		clinic.npc_ui.visible = false
		clinic._transition_to_navigation()
		self.visible = false
