extends RigidBody2D

@export var move_force := 500.0
@export var max_speed := 200.0

func _ready():
	linear_damp = 1.0    # adjust to taste: higher = more drag
	angular_damp = 1.0   # reduce cart spinning

func _physics_process(delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	print(Input.get_action_strength("ui_right"))
	print(input_vector)

	if input_vector.length() > 0:
		var current_velocity = linear_velocity
		apply_force(input_vector * move_force, $PlayerCollision.global_position - global_position)
