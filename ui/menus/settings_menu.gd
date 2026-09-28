extends CanvasLayer

signal resetted

func _ready():
	if Settings.music_volume == 0:
		$Control/Music/Minus.deactivate()
	$Control/Music/Percent.text = str(10 * Settings.music_volume) + "%"
	if Settings.music_volume == 10:
		$Control/Music/Plus.deactivate()
	$Control/SFX/Percent.text = str(10 * Settings.sfx_volume) + "%"

var reset_pressed = 3
func _on_reset_pressed() -> void:
	reset_pressed -= 1
	if reset_pressed == 0:
		SaveData.empty_save().save()
		reset_pressed = 3
		resetted.emit()
	set_reset_text()

func set_reset_text():
	$Control/Reset/Label.text = "Reset progress\npress " + str(reset_pressed) + " time" + ("s" if reset_pressed > 1 else "  ")

func _on_back_pressed() -> void:
	reset_pressed = 3
	set_reset_text()
	
func set_music_volume(value: float) -> void:
	var bus := AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
func set_sfx_volume(value: float) -> void:
	var bus := AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


func _on_minus_pressed() -> void:
	Settings.music_volume -= 1
	if Settings.music_volume == 0:
		$Control/Music/Minus.deactivate()
	if Settings.music_volume < 10:
		$Control/Music/Plus.activate()
	$Control/Music/Percent.text = str(10 * Settings.music_volume) + "%"
	set_music_volume(float(Settings.music_volume) / 10)

func _on_plus_pressed() -> void:
	Settings.music_volume += 1
	if Settings.music_volume > 0:
		$Control/Music/Minus.activate()
	if Settings.music_volume == 10:
		$Control/Music/Plus.deactivate()
	$Control/Music/Percent.text = str(10 * Settings.music_volume) + "%"
	set_music_volume(float(Settings.music_volume) / 10)

func _on_sfx_minus_pressed() -> void:
	Settings.sfx_volume -= 1
	if Settings.sfx_volume == 0:
		$Control/SFX/Minus.deactivate()
	if Settings.sfx_volume < 10:
		$Control/SFX/Plus.activate()
	$Control/SFX/Percent.text = str(10 * Settings.sfx_volume) + "%"
	set_sfx_volume(float(Settings.sfx_volume) / 10)

func _on_sfx_plus_pressed() -> void:
	Settings.sfx_volume += 1
	if Settings.sfx_volume > 0:
		$Control/SFX/Minus.activate()
	if Settings.sfx_volume == 10:
		$Control/SFX/Plus.deactivate()
	$Control/SFX/Percent.text = str(10 * Settings.sfx_volume) + "%"
	set_sfx_volume(float(Settings.sfx_volume) / 10)
