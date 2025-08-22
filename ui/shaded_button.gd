extends TextureButton

@export var is_disabled = false
@export var is_button = true

func _ready():
	self.modulate = Color(1, 1, 1) # Normal color
	if not is_disabled:
		if is_button:
			self.connect("mouse_entered", self._on_mouse_entered)
			self.connect("mouse_exited", self._on_mouse_exited)
			self.connect("button_down", self._on_button_down)
			self.connect("button_up", self._on_button_up)
	elif is_button:  # disabled button
		self.modulate = DEACTIVATED_MODULATE


const HOVER_MODULATE = Color(0.9, 0.9, 0.9)
const DOWN_MODULATE = Color(0.95, 0.95, 0.95)
const DEACTIVATED_MODULATE = Color(0.8, 0.8, 0.8)

func _on_mouse_entered():
	self.modulate = HOVER_MODULATE

func _on_mouse_exited():
	self.modulate = Color(1, 1, 1)

func _on_button_down():
	print("pressed2")
	self.modulate = DOWN_MODULATE

func _on_button_up():
	self.modulate = HOVER_MODULATE
