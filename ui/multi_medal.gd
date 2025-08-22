extends Node2D

var visible_medals = 0

func set_medals(number):
	for i in range(number):
		var medal = [$Bronze, $Silver, $Gold, $Author][i]
		medal.visible = true
	for i in range(number, 4):
		var medal = [$Bronze, $Silver, $Gold, $Author][i]
		medal.visible = false
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


func appear_multiple(medal_level: int, is_pb: bool):
	$DrumRoll.play()
	get_tree().create_timer(max(1.0, 0.5 + medal_level - visible_medals - $Bronze.ANIMATION_DURATION/2)).timeout.connect($DrumRoll.stop)
	print(max(1.0, 0.5 + medal_level - visible_medals - $Bronze.ANIMATION_DURATION/2))
	if not is_pb:
		get_tree().create_timer(1.0).timeout.connect(func (): $Fart.play())
		return 1.
	else:
		if is_pb and medal_level == visible_medals:
			get_tree().create_timer(1.0).timeout.connect(func (): $Bronze.get_node("DrumEnd").play())
			return 1.
		else:
			var actual_time = 0.
			for i in range(visible_medals, medal_level):
				get_tree().create_timer(0.5 + i-visible_medals).timeout.connect(add_medal)
				if i < 3:
					actual_time += $Author.ANIMATION_DURATION
				else:
					actual_time += $Author.ANIMATION_DURATION * 8 / 3
			return actual_time
