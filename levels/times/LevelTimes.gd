extends Resource

class_name LevelTimes

# All the times are in tenths of seconds
@export var pb_time: int = 0

@export var author_time: int = 0
@export var gold_time: int = 0
@export var silver_time: int = 0
@export var bronze_time: int = 0

static func load(level_number: int) -> LevelTimes:
	return load("res://levels/times/level_%d_times.tres" % level_number)
