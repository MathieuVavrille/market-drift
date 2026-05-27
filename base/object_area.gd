extends Area2D

signal is_achieved

var is_done = false

@export var is_end = false

var player: Node2D
@onready var pb = $ProgressBar

var enabled = true
func _ready():
	
	$ObjectStack.set_texture($Object.texture)
	$ObjectStack.rotation = -rotation
	$ObjectStack.visible = not is_end
	$Object.rotation = -rotation
	$Object.visible = not is_end

# TODO add progress bar

var is_achieving = false
var rotation_speed = 0.5
const MAX_SPEED = 50.
const ACHIEVING_TIME = 1.
func _process(delta):
	if not enabled:
		return
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
	if not is_end:
		player.get_object($Object)
	get_tree().create_timer(ACHIEVED_DURATION).timeout.connect(done)

func done():
	is_done = true

func get_texture():
	return $Object.texture
