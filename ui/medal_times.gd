extends Node2D

signal appeared

const APPEAR_TIME = 0.5
func appear(new_time, level_times):
	# Old level times: the pb is not yet updated
	var old_pb = level_times.pb_time
	if level_times.pb_time == 0 or level_times.pb_time > new_time:
		level_times.pb_time = new_time
	set_everything(new_time, level_times)
	$MultiMedal.position = Vector2(0, 0)
	if old_pb > level_times.bronze_time or old_pb == 0:
		$MultiMedal.set_medals(0)
	elif old_pb > level_times.silver_time:
		$MultiMedal.set_medals(1)
	elif old_pb > level_times.gold_time:
		$MultiMedal.set_medals(2)
	elif old_pb > level_times.author_time:
		$MultiMedal.set_medals(3)
	else:
		$MultiMedal.set_medals(4)
	$MultiMedal.modulate.a = 0.
	$MultiTimes.modulate.a = 0.
	get_tree().create_tween().tween_property($MultiMedal, "modulate:a", 1., APPEAR_TIME).set_trans(Tween.TRANS_CUBIC)
	var is_pb = new_time != 0 and old_pb == 0 or new_time < old_pb
	get_tree().create_timer(0.).timeout.connect(func(): appear_medals(new_time, level_times, is_pb))

func appear_medals(new_time, level_times, is_pb):
	var medal_appear_time = 0.
	if new_time > level_times.bronze_time or new_time == 0:
		medal_appear_time = $MultiMedal.appear_multiple(0, is_pb)
	elif new_time > level_times.silver_time:
		medal_appear_time = $MultiMedal.appear_multiple(1, is_pb)
	elif new_time > level_times.gold_time:
		medal_appear_time = $MultiMedal.appear_multiple(2, is_pb)
	elif new_time > level_times.author_time:
		medal_appear_time = $MultiMedal.appear_multiple(3, is_pb)
	else:
		medal_appear_time = $MultiMedal.appear_multiple(4, is_pb)
	get_tree().create_timer(medal_appear_time + 0.25).timeout.connect(move_medals)

func move_medals():
	create_tween().tween_property($MultiMedal, "position:x", $MultiMedalFinalPosition.position.x, 0.5).set_trans(Tween.TRANS_SINE)
	get_tree().create_timer(0.25).timeout.connect(
		func(): create_tween().tween_property($MultiTimes, "modulate:a", 1., APPEAR_TIME))
	get_tree().create_timer(0.25 + APPEAR_TIME).timeout.connect(appeared.emit)

func set_everything(current, level_times):
	visible = true
	$MultiMedal.position = $MultiMedalFinalPosition.position
	$MultiTimes/Logos.position.y = -5
	var text = ""
	if current != 0:
		text += format_time(current) + "\n"
	else:
		$MultiTimes/Logos/FinishL.visible = false
		$MultiTimes/Logos/FinishR.visible = false
		$MultiTimes/Logos.position.y -= 27
	var medal_color = "bronze"
	if level_times.pb_time == 0:
		text += "------"
	else:
		text += format_time(level_times.pb_time)
		if level_times.pb_time <= level_times.bronze_time:
			medal_color = "silver"
		if level_times.pb_time <= level_times.silver_time:
			medal_color = "gold"
		if level_times.pb_time <= level_times.gold_time:
			medal_color = "author"
	$MultiTimes/Logos/MedalL.set_color(medal_color)
	$MultiTimes/Logos/MedalR.set_color(medal_color)
	$MultiTimes/Logos/MedalL.visible = medal_color != "author"
	$MultiTimes/Logos/MedalR.visible = medal_color != "author"
	if medal_color == "author":
		$MultiTimes/Logos.position.y += 23
	else:
		text += "\n"
		if medal_color == "bronze":
			text += format_time(level_times.bronze_time)
		elif medal_color == "silver":
			text += format_time(level_times.silver_time)
		elif medal_color == "gold":
			text += format_time(level_times.gold_time)
	$MultiTimes/Times.text = text


func format_time(tenths: int) -> String:
	var total_seconds := tenths / 10
	var minutes := total_seconds / 60
	var seconds := total_seconds % 60
	var tenth := tenths % 10
	if minutes > 0:
		return "%d:%02d.%d" % [minutes, seconds, tenth]
	else:
		return "%d.%d" % [seconds, tenth]
		
		

func set_times(current, level_times):
	if current > level_times.gold_time:
		$Control/Times/MedalL.visible = false
		$Control/Times/MedalR.visible = false
