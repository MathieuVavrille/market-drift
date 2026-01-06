extends Control

var save_data: SaveData
var all_level_times = []

@onready var original_menu_posx = $MainMenu/Control.position.x
@onready var original_settings_posx = $SettingsMenu/Control.position.x
@onready var original_level_posx = $LevelSelectionMenu/Control.position.x
func _ready():
	get_tree().paused = false
	$MainMenu/Control/Levels/Button.pressed.connect(_on_levels_button_pressed)
	$MainMenu/Control/Settings/Button.pressed.connect(_on_settings_button_pressed)
	$MainMenu/Control/Quit/Button.pressed.connect(_on_quit_button_pressed)
	$LevelSelectionMenu/Control/Back/Button.pressed.connect(_on_level_back_button)
	$SettingsMenu/Control/Back/Button.pressed.connect(_on_settings_back_button)
	save_data = SaveData.load()
	set_all_level_times()
	for i in range(10):
		$LevelSelectionMenu.get_ith_button(i).get_node("Button").mouse_entered.connect(func(): $LevelSelectionMenu.show_medal_times(all_level_times[i]))
		$LevelSelectionMenu.get_ith_button(i).get_node("Button").pressed.connect(func(): on_ith_level_pressed(i))

func set_all_level_times():
	for i in range(10):
		all_level_times.append(LevelTimes.load(i))
		print(all_level_times[i].pb_time)
		var sn = save_data.best_normal_times[i]
		all_level_times[i].pb_time[0] = save_data.best_normal_times[i]
		var sh = save_data.best_hard_times[i]
		all_level_times[i].pb_time[1] = save_data.best_hard_times[i]

const ANIMATION_TIME = 0.5
func change_menu(old_menu, new_menu, width_factor, original_pos):
	var old_control = old_menu.get_node("Control")
	var old_rect = old_control.get_node("TextureRect")
	var new_control = new_menu.get_node("Control")
	var new_rect = new_control.get_node("TextureRect")
	var width = (old_rect.size.x * old_rect.scale.x / 2 + new_rect.size.x * new_rect.scale.x / 2 + 50)
	get_tree().create_tween().tween_property(old_control, "modulate:a", 0., ANIMATION_TIME)
	get_tree().create_timer(ANIMATION_TIME).timeout.connect(func(): old_menu.visible = false)
	get_tree().create_tween().tween_property(old_control, "position:x", original_menu_posx - width * width_factor, ANIMATION_TIME).set_trans(Tween.TRANS_SINE)
	new_control.modulate.a = 0.
	new_menu.visible = true
	get_tree().create_tween().tween_property(new_control, "modulate:a", 1., ANIMATION_TIME)
	new_control.position.x = original_settings_posx + width * width_factor
	get_tree().create_tween().tween_property(new_control, "position:x", original_pos, ANIMATION_TIME).set_trans(Tween.TRANS_SINE)

func _on_levels_button_pressed() -> void:
	if $MainMenu/Control.modulate.a == 1.:
		print("levels")
		change_menu($MainMenu, $LevelSelectionMenu, -1, original_level_posx)
	
func _on_settings_button_pressed() -> void:
	if $MainMenu/Control.modulate.a == 1.:
		change_menu($MainMenu, $SettingsMenu, 1, original_settings_posx)

func _on_quit_button_pressed() -> void:
	if $MainMenu/Control.modulate.a == 1.:
		$SceneChanger.to_next_scene()
	
func _on_level_back_button() -> void:
	if $LevelSelectionMenu/Control.modulate.a == 1.:
		change_menu($LevelSelectionMenu, $MainMenu, 1, original_menu_posx)
		get_tree().create_timer(ANIMATION_TIME).timeout.connect(func(): $LevelSelectionMenu/Control/MedalTimes.visible = false)

func _on_settings_back_button() -> void:
	if $SettingsMenu/Control.modulate.a == 1.:
		change_menu($SettingsMenu, $MainMenu, -1, original_menu_posx)


func on_ith_level_pressed(i: int):
	$SceneChanger.next_scene = load("res://levels/layouts/level_" + str(i) + ".tscn")
	$SceneChanger.to_next_scene()
