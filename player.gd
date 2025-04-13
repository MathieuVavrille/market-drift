extends CharacterBody2D

@export var move_speed := 200.0
@onready var cart = get_node("../Cart")
@onready var joint = $PinJoint2D

func _ready():
	joint.node_b = cart.get_path() # Connect the joint to the cart

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	velocity = input_vector * move_speed
	move_and_slide()

	assist_cart_movement(input_vector)

func assist_cart_movement(direction):
	if not direction or direction.length() == 0:
		return

	var push_force = direction * 300.0 # tweak force strength as needed
	cart.apply_central_force(push_force)
