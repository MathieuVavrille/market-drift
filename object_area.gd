extends Area2D

signal is_achieved

var player: Node2D
@onready var pb = $ProgressBar

var is_achieving = false
var rotation_speed = 0.5
const MAX_SPEED = 50.
const ACHIEVING_TIME = 2.
func _process(delta):
	if is_achieving and pb.value != 1.:
		pb.value += delta / ACHIEVING_TIME
		pb.visible = true
		if pb.value == 1. and pb.visible:
			pb.visible = false
			achieved()
			is_achieving = false
	elif pb.value != 1.:
		pb.visible = false
		pb.value = 0
	var speed_factor = 5 * exp(3 * pb.value**2) - 4
	$Sprite.rotation += rotation_speed * speed_factor * delta
	
func achieved():
	var tween := get_tree().create_tween()
	tween.tween_property($Sprite, "scale", Vector2(0, 0), 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	get_tree().create_timer(1.0).timeout.connect(queue_free)
