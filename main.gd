extends Node2D

const goal_arrow_scene = preload("res://goal_arrow.tscn")

var nb_objects = 0
var start_time = 0
func _ready():
	start_time = Time.get_ticks_msec()
	nb_objects = len($Objects.get_children())
	for object in $Objects.get_children():
		object.is_achieved.connect(object_area_achieved)
		instantiate_goal_arrow(object, object.get_texture())

func instantiate_goal_arrow(object, texture):
	var goal_arrow = goal_arrow_scene.instantiate()
	goal_arrow.camera = $PlayerCart.get_camera()
	goal_arrow.target = object
	goal_arrow.set_sprite(texture)
	add_child(goal_arrow)

var nb_achieved = 0
func object_area_achieved():
	nb_achieved += 1
	if nb_achieved == nb_objects:
		$Register.activate()
		instantiate_goal_arrow($Register/Area, null)


func _on_register_finished() -> void:
	var total_time_ms = Time.get_ticks_msec() - start_time
	print(total_time_ms)
