extends Control

func _ready():
	$MainMenu/Control/Levels/Button.pressed.connect(_on_levels_button_pressed)
	$MainMenu/Control/Settings/Button.pressed.connect(_on_settings_button_pressed)
	$MainMenu/Control/Quit/Button.pressed.connect(_on_quit_button_pressed)
	
	


func _on_levels_button_pressed() -> void:
	print("levels")


func _on_settings_button_pressed() -> void:
	print("settings")


func _on_quit_button_pressed() -> void:
	print("quit")
