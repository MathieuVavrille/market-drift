extends Resource

class_name SaveData

const SAVE_PATH = "user://save.tres"

@export var volume: int = 10

@export var best_normal_times := []
@export var best_hard_times := []

@export var mode_change_shown := false


static func load() -> SaveData:
	if FileAccess.file_exists(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH) as SaveData
	else:
		var save_data = SaveData.empty_save()
		save_data.save()
		return save_data

static func empty_save() -> SaveData:
	var save_data = SaveData.new()
	for i in range(10):
		save_data.best_normal_times.append(0)
		save_data.best_hard_times.append(0)
	return save_data

func save():
	ResourceSaver.save(self, SAVE_PATH)

func get_level_pb(level_number: int, easy_mode: bool = false):
	var save_data = SaveData.load()
	if easy_mode:
		return save_data.best_easy_times[level_number]
	else:
		return save_data.best_hard_times[level_number]

static func set_level_pb(level_number: int, new_time: int):
	var save_data = SaveData.load()
	var times = save_data.best_normal_times if Settings.difficulty == 0 else save_data.best_hard_times
	if times[level_number] == 0 or new_time < times[level_number]:
		times[level_number] = new_time
	save_data.save()
