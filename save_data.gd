extends Resource

class_name SaveData

const SAVE_PATH = "user://save.tres"

@export var volume: int = 10

@export var best_easy_times := []
@export var best_hard_times := []

static func load():
	if FileAccess.file_exists(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH) as SaveData
	else:
		var save_data = SaveData.new()
		for i in range(10):
			save_data.best_easy_times.append(0)
			save_data.best_hard_times.append(0)
		save_data.save()
		return save_data

func save():
	ResourceSaver.save(self, SAVE_PATH)
