extends Sprite2D

@export_enum("bronze", "silver", "gold", "author") var color: String = "bronze"

var original_scale = 1.
func _ready():
	original_scale = scale.x

func set_medal_color(new_color):
	color = new_color
	texture = load("res://assets/medals/" + color + ".png")
	match color:
		"bronze": $DrumEnd.pitch_scale = 1.0
		"silver": $DrumEnd.pitch_scale = 1.1
		"gold": $DrumEnd.pitch_scale = 1.2
		"author": $DrumEnd.pitch_scale = 1.3
	


const ANIMATION_DURATION = 1. 
func appear():
	visible = true
	scale = 2 * Vector2(original_scale, original_scale)
	get_tree().create_tween().tween_property(self, "scale", Vector2(original_scale, original_scale), ANIMATION_DURATION).set_trans(Tween.TRANS_CUBIC)#.set_ease(Tween.EASE_OUT)
	rotation_degrees = 180
	get_tree().create_tween().tween_property(self, "rotation_degrees", 0, ANIMATION_DURATION).set_trans(Tween.TRANS_CUBIC)#.set_ease(Tween.EASE_OUT)
	modulate.a = 0
	get_tree().create_tween().tween_property(self, "modulate:a", 1, ANIMATION_DURATION).set_trans(Tween.TRANS_CUBIC)#.set_ease(Tween.EASE_OUT)
	get_tree().create_timer(ANIMATION_DURATION / 2).timeout.connect($DrumEnd.play)
