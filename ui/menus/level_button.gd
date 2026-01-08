extends Node2D

func activate():
	$Button.is_deactivated = false
	$Button._ready()

func deactivate():
	$Button.is_deactivated = true
	$Button._ready()

func set_medal(level_time: LevelTimes):
	$Author.visible = false
	$Gold.visible = false
	$Silver.visible = false
	$Bronze.visible = false
	if level_time.pb_time[Settings.difficulty] == 0:
		return
	if level_time.pb_time[Settings.difficulty] <= level_time.author_time[Settings.difficulty]:
		$Author.visible = true
	elif level_time.pb_time[Settings.difficulty] <= level_time.gold_time[Settings.difficulty]:
		$Gold.visible = true
	elif level_time.pb_time[Settings.difficulty] <= level_time.silver_time[Settings.difficulty]:
		$Silver.visible = true
	elif level_time.pb_time[Settings.difficulty] <= level_time.bronze_time[Settings.difficulty]:
		$Bronze.visible = true
