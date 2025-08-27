extends CanvasLayer

var level_button_scene = preload("res://ui/menus/level_button.tscn")

const button_spacing = 80

func _ready():
	for level in range(10):
		var i = level / 5
		var j = level % 5
		var button = level_button_scene.instantiate()
		$Control/Levels.add_child(button)
		button.get_node("Label").text = str(level)
		button.position = Vector2((j-2) * button_spacing, (i - 0.5) * button_spacing)

func get_ith_button(i):
	print($Control/Levels.get_child(i))
	return $Control/Levels.get_child(i)

func show_medal_times(level_times: LevelTimes):
	$Control/MedalTimes.visible = true
	$Control/MedalTimes.set_everything(0, level_times)
