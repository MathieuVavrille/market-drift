extends CanvasLayer

var level_times: LevelTimes
var is_paused = false
var is_started = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and is_started:
		if visible:
			if is_paused:
				visible = false
				get_tree().paused = false
		else:
			pause_level()
			get_tree().paused = true

func pause_level():
	is_paused = true
	visible = true
	$Control/Title.text="Level Paused"
	$Control/MedalTimes.set_everything(0, level_times)

func end_level(new_time: int):
	visible = true
	$Control/Title.text="Level Completed"
	$Control/Restart.modulate.a = 0.
	$Control/Next.modulate.a = 0.
	$Control/Menu.modulate.a = 0.
	visible = true
	$Control.modulate.a = 0.
	create_tween().tween_property($Control, "modulate:a", 1., 0.5)
	$Control/MedalTimes.appear(new_time, level_times)

const BUTTON_APPEAR_TIME = 0.5
func _on_medal_times_appeared() -> void:
	create_tween().tween_property($Control/Restart, "modulate:a", 1., BUTTON_APPEAR_TIME)#.set_trans(Tween.TRANS_CUBIC)
	create_tween().tween_property($Control/Next, "modulate:a", 1., BUTTON_APPEAR_TIME)#.set_trans(Tween.TRANS_CUBIC)
	create_tween().tween_property($Control/Menu, "modulate:a", 1., BUTTON_APPEAR_TIME)#.set_trans(Tween.TRANS_CUBIC)


func _on_restart_button_pressed() -> void:
	print("restart")


func _on_next_button_pressed() -> void:
	print("next")


func _on_menu_button_pressed() -> void:
	print("menu")
