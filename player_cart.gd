extends RigidBody2D

@export var move_force := 1000.0
@export var max_speed := 200.0

var FRICTION_STRENGTH = move_force / max_speed * 10

func true_movement(cart_direction, input_vector):
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

func turn_movement(cart_direction, input_vector):
	var proj = (input_vector.dot(cart_direction) / cart_direction.length_squared()) * cart_direction
	var orth = input_vector - proj
	var cross = input_vector.cross(cart_direction)
	apply_torque(-cross * 2500)
	var force_position = $PlayerMesh.global_position - global_position
	apply_force(proj * move_force, force_position)

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
			turn_movement(cart_direction, input_vector)
		else:
			true_movement(cart_direction, input_vector)
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
	
func get_random_point_in_placeholder() -> Vector2:  # TODO a better area than a rectangle: trapezoid would be better
	var shape = $PlaceholderRectangle.shape as RectangleShape2D
	var extents = shape.extents
	var random_x = randf_range(-extents.x, extents.x)
	var random_y = randf_range(-extents.y, extents.y)
	return $PlaceholderRectangle.position + Vector2(random_x, random_y)
	
func get_object(object: Node2D):
	ChildExchange.exchange(object, self)
	var tween = get_tree().create_tween()
	var goal_position = get_random_point_in_placeholder()
	tween.tween_property(object, "position", goal_position, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	
	
	
	
