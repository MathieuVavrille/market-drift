extends CanvasLayer

var level_button_scene = preload("res://ui/menus/level_button.tscn")

const button_spacing = 80

func _ready():
	for level in range(10):
		@warning_ignore("integer_division")
		var i = level / 5
		var j = level % 5
		var button = level_button_scene.instantiate()
		$Control/Levels.add_child(button)
		button.get_node("Label").text = str(level)
		button.position = Vector2((j-2) * button_spacing, (i - 0.5) * button_spacing)


func get_ith_button(i):
	return $Control/Levels.get_child(i)

var latest_level_times = null
func show_medal_times(level_times: LevelTimes):
	latest_level_times = level_times
	$Control/MedalTimes.visible = true
	$Control/MedalTimes.set_everything(0, level_times)


func _on_difficulty_button_pressed() -> void:
	if Settings.difficulty == 0 and $Control/Mode/DifficultyBackground.position.y == $Control/Mode/NormalPosition.position.y:
		Settings.difficulty = 1
		create_tween().tween_property($Control/Mode/DifficultyBackground, "position:y", $Control/Mode/HardPosition.position.y, 0.25).set_trans(Tween.TRANS_CUBIC)
		$Control/MedalTimes.visible = false
		if latest_level_times != null:
			show_medal_times(latest_level_times)
	elif Settings.difficulty == 1 and $Control/Mode/DifficultyBackground.position.y == $Control/Mode/HardPosition.position.y:
		Settings.difficulty = 0
		create_tween().tween_property($Control/Mode/DifficultyBackground, "position:y", $Control/Mode/NormalPosition.position.y, 0.25).set_trans(Tween.TRANS_CUBIC)
		$Control/MedalTimes.visible = false
		if latest_level_times != null:
			show_medal_times(latest_level_times)
