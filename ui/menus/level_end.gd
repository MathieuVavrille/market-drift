extends CanvasLayer

signal restart
signal menu
signal next

var level_times: LevelTimes
var is_paused = false
var is_started = false
var is_ended = false

func deactivate_next():
	$Control/Next/Button.modulate = $Control/Next/Button.DEACTIVATED_MODULATE
	$Control/Next/Button.disabled = true

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and is_started and not is_ended:
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
	is_ended = true
	$Control/Title.text="Level Completed"
	$Control/Restart.modulate.a = 0.
	$Control/Next.modulate.a = 0.
	$Control/Menu.modulate.a = 0.
	$Control.modulate.a = 0.
	create_tween().tween_property($Control, "modulate:a", 1., 0.5)
	$Control/MedalTimes.appear(new_time, level_times)
	visible = true

const BUTTON_APPEAR_TIME = 0.5
func _on_medal_times_appeared() -> void:
	create_tween().tween_property($Control/Restart, "modulate:a", 1., BUTTON_APPEAR_TIME)#.set_trans(Tween.TRANS_CUBIC)
	create_tween().tween_property($Control/Next, "modulate:a", 1., BUTTON_APPEAR_TIME)#.set_trans(Tween.TRANS_CUBIC)
	create_tween().tween_property($Control/Menu, "modulate:a", 1., BUTTON_APPEAR_TIME)#.set_trans(Tween.TRANS_CUBIC)


func _on_restart_button_pressed() -> void:
	restart.emit()

func _on_next_button_pressed() -> void:
	next.emit()

func _on_menu_button_pressed() -> void:
	menu.emit()
