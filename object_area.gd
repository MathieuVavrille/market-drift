extends Area2D

signal is_achieved

var player: Node2D
@onready var pb = $ProgressBar

func _ready():
	$Object.rotation = -rotation

# TODO add progress bar

var is_achieving = false
var rotation_speed = 0.5
const MAX_SPEED = 50.
const ACHIEVING_TIME = 2.
func _process(delta):
	if is_achieving and pb.value != 1.:
		pb.value += delta / ACHIEVING_TIME
		if pb.value == 1.:
			pb.visible = false
			achieved()
			is_achieving = false
	elif pb.value != 1.:
		pb.value = 0
	var speed_factor = 10 * exp(2 * pb.value**2) - 8
	$Vortex.rotation += rotation_speed * speed_factor * delta

const ACHIEVED_DURATION = 0.25
func achieved():
	is_achieved.emit()
	var tween := get_tree().create_tween()
	tween.tween_property($Vortex, "scale", Vector2(0, 0), ACHIEVED_DURATION).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	player.get_object($Object)
	get_tree().create_timer(1.0).timeout.connect(queue_free)

func get_texture():
	return $Object.texture
