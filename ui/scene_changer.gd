extends CanvasLayer

signal scene_started

@export var fade_time = 0.5
@export var next_scene: PackedScene
@export var root: String

func start_scene():
	$ColorRect.modulate.a = 1.
	create_tween().tween_property($ColorRect, "modulate:a", 0., fade_time).set_trans(Tween.TRANS_SINE)
	get_tree().create_timer(fade_time).timeout.connect(scene_started.emit)

func to_next_scene():
	$ColorRect.modulate.a = 0.
	create_tween().tween_property($ColorRect, "modulate:a", 1., fade_time).set_trans(Tween.TRANS_SINE)
	get_tree().create_timer(fade_time).timeout.connect(on_fade_out)

func on_fade_out():
	if next_scene == null:
		get_tree().quit()
	else:
		#get_tree().change_scene_to_packed(next_scene)
		get_tree().root.add_child(next_scene.instantiate())
		get_node("/root/Chapter1Outside").queue_free()
