extends Resource

class_name LevelTimes

# All the times are in tenths of seconds
@export var pb_time: Array[int] = [0, 0]

@export var author_time: Array[int] = [0, 0]
@export var gold_time: Array[int] = [0, 0]
@export var silver_time: Array[int] = [0, 0]
@export var bronze_time: Array[int] = [0, 0]

static func load(level_number: int) -> LevelTimes:
	var level_times = load("res://levels/times/level_%d_times.tres" % level_number)
	for i in range(2):
		if level_times.gold_time[i] == 0:
			level_times.gold_time[i] = int(1.1 * level_times.author_time[i])
		if level_times.silver_time[i] == 0:
			level_times.silver_time[i] = int(1.5 * level_times.author_time[i])
		if level_times.bronze_time[i] == 0:
			level_times.bronze_time[i] = 2 * level_times.author_time[i]
	return level_times
