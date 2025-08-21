extends CanvasLayer


func appear(current_time: float, level_times: LevelTimes):
	print("appear")

func format_time(time_seconds: float) -> String:
	# floor to the tenth
	var tenths := int(floor(time_seconds * 10.0)) 
	var total_seconds := tenths / 10
	var minutes := total_seconds / 60
	var seconds := total_seconds % 60
	var tenth := tenths % 10
	if minutes > 0:
		return "%d:%02d.%d" % [minutes, seconds, tenth]
	else:
		return "%02d.%d" % [seconds, tenth]


func set_times(current, level_times):
	if current > level_times.gold_time:
		$Control/Times/MedalL.visible = false
		$Control/Times/MedalR.visible = false


func _on_restart_button_pressed() -> void:
	print("restart")


func _on_next_button_pressed() -> void:
	print("next")


func _on_quit_button_pressed() -> void:
	print("quit")
