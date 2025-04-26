extends RigidBody2D

@export var move_force := 1000.0
@export var max_speed := 200.0

var FRICTION_STRENGTH = move_force / max_speed * 10

func _physics_process(_delta):
	var cart_direction = ($CartMesh.global_position - $PlayerMesh.global_position).normalized()
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	# Drag
	apply_central_force(-linear_velocity * FRICTION_STRENGTH)
	apply_torque(-angular_velocity * 20)
	
	if input_vector != Vector2.ZERO:
		if Input.is_action_pressed("turn"):
			var proj = (input_vector.dot(cart_direction) / cart_direction.length_squared()) * cart_direction
			var orth = input_vector - proj
			var cross = input_vector.cross(cart_direction)
			apply_torque(-cross * 2500)
			var force_position = $PlayerMesh.global_position - global_position
			apply_force(proj * move_force, force_position)
		else:
			var current_velocity = linear_velocity
			var force_position = $PlayerMesh.global_position - global_position
			var angle = cart_direction.angle_to(input_vector)
			if angle < -PI:
				angle += PI
			if angle > PI:
				angle -= PI
			if abs(angle) < PI/16:
				apply_torque(angle * 10000)
			if abs(angle) < PI/2:
				apply_force(input_vector * move_force, force_position)
			else:
				apply_force(input_vector * move_force / 1, force_position)
	else: # no movement
		if inside_object != null:
			apply_central_force(-linear_velocity * 100)
			apply_torque(-angular_velocity * 1000)
			if linear_velocity.length() < 0.25 and abs(angular_velocity) < 0.1:
				linear_velocity = Vector2.ZERO
				angular_velocity = 0

func is_stopped():
	return linear_velocity == Vector2.ZERO and angular_velocity == 0

func _process(delta: float) -> void:
	if inside_object != null:
		inside_object.is_achieving = is_stopped()


var inside_object = null
func entered_object(area: Area2D) -> void:
	inside_object = area
	area.player = self
	area.is_achieving = false
func object_exited(_area: Area2D) -> void:
	inside_object = null
