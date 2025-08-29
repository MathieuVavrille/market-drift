extends Control

var save_data: SaveData
var all_level_times = []

@onready var original_menu_posx = $MainMenu/Control.position.x
@onready var original_settings_posx = $SettingsMenu/Control.position.x
@onready var original_level_posx = $LevelSelectionMenu/Control.position.x
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
		all_level_times.append(LevelTimes.load(i))
		all_level_times[i].pb_time = save_data.best_hard_times[i]

const ANIMATION_TIME = 1.
func _on_levels_button_pressed() -> void:
	# TODO nice animation
	$MainMenu.visible = false
	$LevelSelectionMenu.visible = true

func _on_settings_button_pressed() -> void:
	# TODO nice animation
	var width = ($MainMenu/Control/TextureRect.size.x * $MainMenu/Control/TextureRect.scale.x / 2
				+ $SettingsMenu/Control/TextureRect.size.x * $SettingsMenu/Control/TextureRect.scale.x / 2
				+ 50)
	create_tween().tween_property($MainMenu/Control, "modulate:a", 0., ANIMATION_TIME)
	create_tween().tween_property($MainMenu/Control, "position:x", original_menu_posx - width, ANIMATION_TIME).set_trans(Tween.TRANS_SINE)
	#get_tree().create_timer(ANIMATION_TIME).timeout.connect(func(): $MainMenu.visible = false)
	$SettingsMenu/Control.modulate.a = 0.
	$SettingsMenu.visible = true
	create_tween().tween_property($SettingsMenu/Control, "modulate:a", 1., ANIMATION_TIME)
	$SettingsMenu/Control.position.x = original_settings_posx + width
	create_tween().tween_property($SettingsMenu/Control, "position:x", original_settings_posx, ANIMATION_TIME).set_trans(Tween.TRANS_SINE)


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
	
