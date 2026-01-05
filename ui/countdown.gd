extends Label

signal go

const SECOND_TIME = 0.1#1.

func start():
	visible = true
	count_down(3)
	get_tree().create_timer(SECOND_TIME).timeout.connect(func(): count_down(2))
	get_tree().create_timer(SECOND_TIME * 2).timeout.connect(func(): count_down(1))
	get_tree().create_timer(SECOND_TIME * 3).timeout.connect(count_go)

func _process(_delta):
	rotation = 0

const FRACTION = 5
func count_down(i):
	text = str(i)
	$CountSound.play()
	modulate.a = 1.
	create_tween().tween_property(self, "modulate:a", 0., SECOND_TIME * (FRACTION - 1) / FRACTION).set_trans(Tween.TRANS_CUBIC)

func count_go():
	text = "GO"
	$GoSound.play()
	modulate.a = 0.5
	create_tween().tween_property(self, "modulate:a", 0., SECOND_TIME / 2)
	go.emit()
