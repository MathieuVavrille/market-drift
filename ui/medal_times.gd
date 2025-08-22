extends Node2D

func appear(current, level_times):
	print("appear medal times")
	
func set_everything(current, level_times):
	$MultiTimes/Logos.position.y = -5
	var text = ""
	if current == null:
		text += format_time(current) + "\n"
		$MultiTimes/Logos/FinishL.visible = false
		$MultiTimes/Logos/FinishR.visible = false
		$MultiTimes/Logos.position.y += 25
	var medal_color = "bronze"
	if level_times.pb == null:
		text += "------"
	else:
		text += format_time(level_times.pb_time)
		if level_times.pb > level_times.bronze_time:
			medal_color = "silver"
		if level_times.pb > level_times.silver_time:
			medal_color = "gold"
		if level_times.pb > level_times.gold:
			medal_color = "author"
	$MultiTimes/Logos/MedalL.set_color(medal_color)
	$MultiTimes/Logos/MedalL.set_color(medal_color)
	$MultiTimes/Logos/MedalL.visible = medal_color != "author"
	$MultiTimes/Logos/MedalL.visible = medal_color != "author"
	if medal_color == "author":
		$MultiTimesLogos.position.y -= 25
	else:
		text += "\n"
		if medal_color == "bronze":
			text += format_time(level_times.bronze_time)
		elif medal_color == "gold":
			text += format_time(level_times.bronze_time)
		elif medal_color == "gold":
			text += format_time(level_times.bronze_time)


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
