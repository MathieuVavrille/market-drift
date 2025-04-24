extends Node2D

# Assuming this is in a script attached to the arrow or a manager node
@export var camera: Camera2D
@export var target: Node2D


@onready var target_visibility = target.get_node("VisibleOnScreenNotifier2D")

func _process(_delta):
	visible = not target_visibility.is_on_screen()
	var viewport_size = get_viewport().size
	var angle = (target.global_position - camera.global_position).angle()
	global_rotation = angle
	var ellipsis_vector = Vector2(cos(angle) * (viewport_size.x / 2.1 - 10),
					  sin(angle) * (viewport_size.y / 2.1 - 10)) / camera.zoom  #TODO compute properly
	var rectangle_vector = get_square_border_intersection(angle, viewport_size) / 2.1 / camera.zoom
	global_position = camera.get_screen_center_position() + (ellipsis_vector + 2 * rectangle_vector) / 3

func get_square_border_intersection(angle: float, size: Vector2) -> Vector2:
	var dir = Vector2(cos(angle), sin(angle)).normalized()
	var dx = dir.x
	var dy = dir.y

	var scale_x = INF
	var scale_y = INF

	if dx != 0.0:
		scale_x = size.x / abs(dx)
	if dy != 0.0:
		scale_y = size.y / abs(dy)

	var scale = min(scale_x, scale_y)
	return dir * scale
