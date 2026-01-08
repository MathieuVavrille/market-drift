extends Resource

class_name LevelTimes

# All the times are in tenths of seconds
@export var pb_time = [0, 0]

@export var author_time = [0, 0]
@export var gold_time = [0, 0]
@export var silver_time = [0, 0]
@export var bronze_time = [0, 0]

static func load(level_number: int) -> LevelTimes:
	var level_times = load("res://levels/times/level_%d_times.tres" % level_number)
	for i in range(2):
		if level_times.gold_time[i] == 0:
			level_times.gold_time[i] = int(1.1 * level_times.author_time[i])
		if level_times.silver_time[i] == 0:
			level_times.silver_time[i] = int(1.5 * level_times.author_time[i])
		if level_times.bronze_time[i] == 0:
			level_times.bronze_time[i] = 2 * level_times.author_time[i]
	var save_data = SaveData.load()
	level_times.pb_time = [save_data.best_normal_times[level_number], save_data.best_hard_times[level_number]]
	return level_times
