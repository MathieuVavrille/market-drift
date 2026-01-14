extends CanvasLayer

var level_button_scene = preload("res://ui/menus/level_button.tscn")

var all_level_times = null
const button_spacing = 80

var buttons = []
func _ready():
	$Control/Mode.visible = SaveData.load().best_normal_times[1] != 0
	for level in range(10):
		@warning_ignore("integer_division")
		var i = level / 5
		var j = level % 5
		var button = level_button_scene.instantiate()
		$Control/Levels.add_child(button)
		button.get_node("Label").text = str(level)
		button.position = Vector2((j-2) * button_spacing, (i - 0.5) * button_spacing)
		buttons.append(button)
	if Settings.difficulty == 0:
		$Control/Mode/DifficultyBackground.position.y = $Control/Mode/NormalPosition.position.y
	else:
		$Control/Mode/DifficultyBackground.position.y = $Control/Mode/HardPosition.position.y

func set_all_buttons():
	for i in range(10):
		buttons[i].set_medal(all_level_times[i])
		if i > 0 and all_level_times[i-1].pb_time[Settings.difficulty] == 0:
			buttons[i].deactivate()
		else:
			buttons[i].activate()

func get_ith_button(i):
	return $Control/Levels.get_child(i)

var latest_level_selected = -1
func show_medal_times(level_number):
	if level_number == 0 or all_level_times[level_number - 1].pb_time[Settings.difficulty] != 0:
		latest_level_selected = level_number
		var level_times = all_level_times[level_number]
		$Control/MedalTimes.visible = true
		$Control/MedalTimes.set_everything(0, level_times)


func _on_difficulty_button_pressed() -> void:
	var pressed = false
	if Settings.difficulty == 0 and $Control/Mode/DifficultyBackground.position.y == $Control/Mode/NormalPosition.position.y:
		Settings.difficulty = 1
		create_tween().tween_property($Control/Mode/DifficultyBackground, "position:y", $Control/Mode/HardPosition.position.y, 0.25).set_trans(Tween.TRANS_CUBIC)
		pressed = true
	elif Settings.difficulty == 1 and $Control/Mode/DifficultyBackground.position.y == $Control/Mode/HardPosition.position.y:
		Settings.difficulty = 0
		create_tween().tween_property($Control/Mode/DifficultyBackground, "position:y", $Control/Mode/NormalPosition.position.y, 0.25).set_trans(Tween.TRANS_CUBIC)
		pressed = true
	if pressed:
		$Control/MedalTimes.visible = false
		if latest_level_selected != -1:
			show_medal_times(latest_level_selected)
		set_all_buttons()

const FADE_TIME = 1.
const FOCUS_TIME = 4.
func show_mode_change():
	$Focus.modulate.a = 0.
	create_tween().tween_property($Focus, "modulate:a", 1., FADE_TIME).set_trans(Tween.TRANS_CUBIC)
	get_tree().create_timer(FOCUS_TIME).timeout.connect(finish_mode_change)
	
func finish_mode_change():
	create_tween().tween_property($Focus, "modulate:a", 0., FADE_TIME).set_trans(Tween.TRANS_CUBIC)
