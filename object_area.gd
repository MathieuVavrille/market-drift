extends Area2D

signal is_achieved

var is_achieving = false
var rotation_speed = 0.25
const MAX_SPEED = 50.
func _process(delta):
	$ProgressBar.value += delta
	var speed_factor = 5 * exp(3 * $ProgressBar.value**2) - 4
	rotation += rotation_speed * speed_factor * delta
	
func achieved():
	var tween := get_tree().create_tween()
	tween.tween_property(
		$Sprite, # Replace with your actual node path
		"scale",
		Vector2(0, 0),
		1.0 # Duration in seconds
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	get_tree().create_timer(1.0).timeout.connect(queue_free)
