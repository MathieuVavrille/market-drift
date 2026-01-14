extends CanvasLayer

signal resetted

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
