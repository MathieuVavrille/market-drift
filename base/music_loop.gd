extends AudioStreamPlayer

var current_music = 0

func _ready():
	current_music = randi_range(0, 2)
	stream = load("res://assets/music/music_lounge" + str(current_music) + ".mp3")
	
func launch_new_music():
	current_music = (current_music + randi_range(0, 1)) % 3
	stream = load("res://assets/music/music_lounge" + str(current_music) + ".mp3")

func _on_finished() -> void:
	launch_new_music()
