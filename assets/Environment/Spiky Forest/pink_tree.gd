extends Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Randomly pick a tree size and frame
	var tree_sizes = ["BigTree.png", "MediumTree.png", "SmallTree.png"]
	var random_size = tree_sizes[randi() % tree_sizes.size()]
	var random_frame = randi() % 3

	# Load the texture and set the frame
	texture = load("res://assets/Environment/Spiky Forest/" + random_size)
	hframes = 3
	frame = random_frame

	# Apply a slightly random scale
	var random_scale = randf_range(0.75, 1.5)
	scale = Vector3(random_scale, random_scale, random_scale)

	# Randomly flip horizontally 50% of the time
	flip_h = randi() % 2 == 0

	# Apply slight random variations to position
	position.x += randf_range(-0.25, 0.25)
	position.y += randf_range(-0.25, 0.25)
