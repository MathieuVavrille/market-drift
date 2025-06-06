extends Node2D

# Assuming this is in a script attached to the arrow or a manager node
@export var camera: Camera2D
@export var target: Node2D


@onready var target_visibility = target.get_node("VisibleOnScreenNotifier2D")

const ELLIPSIS_PROPORTION = 0.33

func _process(_delta):
	if target == null:
		queue_free()
		return
	visible = not target_visibility.is_on_screen()
	var viewport_size = get_viewport().size
	var angle = (target.global_position - camera.global_position).angle()
	global_rotation = angle
	var ellipsis_vector = Vector2(cos(angle) * (viewport_size.x / 2.1 - 10),
					  sin(angle) * (viewport_size.y / 2.1 - 20)) / camera.zoom  #TODO compute properly
	var rectangle_vector = get_square_border_intersection(angle, viewport_size - Vector2i.ONE * 20) / 2.1 / camera.zoom
	global_position = camera.get_screen_center_position() + ellipsis_vector * ELLIPSIS_PROPORTION + rectangle_vector * (1 - ELLIPSIS_PROPORTION)

func get_square_border_intersection(angle: float, size: Vector2) -> Vector2:
	var dir = Vector2(cos(angle), sin(angle)).normalized()
	var border_scale = min(abs(size.x / dir.x), abs(size.y / dir.y))
	return dir * border_scale

func set_sprite(object_texture):
	$ObjectSprite.texture = object_texture
