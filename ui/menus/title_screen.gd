extends Control

var save_data: SaveData
var all_level_times = []

func _ready():
	$MainMenu/Control/Levels/Button.pressed.connect(_on_levels_button_pressed)
	$MainMenu/Control/Settings/Button.pressed.connect(_on_settings_button_pressed)
	$MainMenu/Control/Quit/Button.pressed.connect(_on_quit_button_pressed)
	$LevelSelectionMenu/Control/Back/Button.pressed.connect(_on_level_back_button)
	$SettingsMenu/Control/Back/Button.pressed.connect(_on_settings_back_button)
	save_data = SaveData.load()
	set_all_level_times()
	for i in range(10):
		$LevelSelectionMenu.get_ith_button(i).get_node("Button").mouse_entered.connect(func(): $LevelSelectionMenu.show_medal_times(all_level_times[i]))
		$LevelSelectionMenu.get_ith_button(i).get_node("Button").pressed.connect(func(): print("level ", i))

func set_all_level_times():
	for i in range(10):
		var level_path = "res://levels/level_%d.tscn" % 0  # TODO i
		all_level_times.append(load(level_path).instantiate().get_node("LevelTimes"))
		all_level_times[i].pb_time = save_data.best_hard_times[i]


func _on_levels_button_pressed() -> void:
	# TODO nice animation
	$MainMenu.visible = false
	$LevelSelectionMenu.visible = true

func _on_settings_button_pressed() -> void:
	# TODO nice animation
	$MainMenu.visible = false
	$SettingsMenu.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func _on_level_back_button() -> void:
	# TODO nice animation
	$LevelSelectionMenu.visible = false
	$LevelSelectionMenu/Control/MedalTimes.visible = false
	$MainMenu.visible = true

func _on_settings_back_button() -> void:
	# TODO animation
	$SettingsMenu.visible = false
	$MainMenu.visible = true
	
