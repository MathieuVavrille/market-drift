extends Node2D

var visible_medals = 0

func set_medals(number):
	for i in range(number):
		var medal = [$Bronze, $Silver, $Gold, $Author][i]
		medal.visible = true
	visible_medals = number


func add_medal():
	if not $Bronze.visible:
		$Bronze.appear()
	elif not $Silver.visible:
		$Silver.appear()
	elif not $Gold.visible:
		$Gold.appear()
	else:
		$Author.appear()
		for i in range(3):
			var medal = [$Bronze, $Silver, $Gold][i]
			var tween = get_tree().create_tween()
			tween.tween_property(medal, "modulate:a", 0, $Author.ANIMATION_DURATION).set_trans(Tween.TRANS_CUBIC)#.set_ease(Tween.EASE_OUT))
			tween.tween_interval($Author.ANIMATION_DURATION / 3 * i)
			tween.tween_property(medal, "modulate:a", 1, $Author.ANIMATION_DURATION)#.set_trans(Tween.TRANS_CUBIC)#.set_ease(Tween.EASE_OUT))
