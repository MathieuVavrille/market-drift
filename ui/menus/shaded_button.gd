extends TextureButton

@export var is_disabled: bool = false
@export var is_deactivated: bool = false

const HOVER_MODULATE = Color(0.9, 0.9, 0.9)
const DOWN_MODULATE = Color(0.95, 0.95, 0.95)
const DEACTIVATED_MODULATE = Color(0.8, 0.8, 0.8)

func _ready():
	self.modulate = Color(1, 1, 1) # Normal color
	if is_deactivated:
		self.modulate = DEACTIVATED_MODULATE
		disabled = true
	elif is_disabled:
		disabled = true


func activate():
	disabled = false
	self.modulate = Color(1, 1, 1)
func deactivate():
	disabled = true
	self.modulate = DEACTIVATED_MODULATE


func _on_mouse_entered():
	if not disabled:
		self.modulate = HOVER_MODULATE

func _on_mouse_exited():
	if not disabled:
		self.modulate = Color(1, 1, 1)

func _on_button_down():
	if not disabled:
		self.modulate = DOWN_MODULATE

func _on_button_up():
	if not disabled:
		self.modulate = HOVER_MODULATE
