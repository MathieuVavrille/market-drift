extends Node2D

const goal_arrow_scene = preload("res://goal_arrow.tscn")

func _ready():
	for object in $Objects.get_children():
		object.is_achieved.connect(object_area_achieved)
		var goal_arrow = goal_arrow_scene.instantiate()
		goal_arrow.camera = $PlayerCart.get_camera()
		goal_arrow.target = object
		goal_arrow.set_sprite(object.get_texture())
		add_child(goal_arrow)

var nb_achieved = 0
func object_area_achieved():
	nb_achieved += 1
	if $Objects.get_child_count() == 1:
		print("finished")
