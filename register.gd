extends StaticBody2D

signal finished

@export var player: RigidBody2D

func _ready():
	$Area.visible = false
	$Area.enabled = false


func activate():
	$Area.visible = true
	$Area.enabled = true
	
const TIME_TO_BELT = 0.5
const TIME_TO_SCAN = 0.5
func get_object(object: Node2D):
	ChildExchange.exchange(object, self)
	object.z_index = 1
	var tween = get_tree().create_tween()
	tween.tween_property(object, "position", $ConveyorStart.position, TIME_TO_BELT).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(object, "position", $ConveyorEnd.position, TIME_TO_SCAN).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

const OBJECTS_DELAY = 0.33
func _on_area_is_achieved() -> void:
	player.set_process(false)
	player.set_physics_process(false)
	var delay = 0.01
	for object in player.get_node("Objects").get_children():
		get_tree().create_timer(delay).timeout.connect(func(): get_object(object))
		get_tree().create_timer(delay + TIME_TO_BELT + TIME_TO_SCAN / 2).timeout.connect(beep)
		delay += OBJECTS_DELAY
	get_tree().create_timer(delay + TIME_TO_BELT + TIME_TO_SCAN).timeout.connect(finished.emit)
	
var pitch_variation = 0.1
func beep():
	$BeepPlayer.pitch_scale = 1.0 + randf_range(0, pitch_variation)
	$BeepPlayer.play()
