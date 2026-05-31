extends Node2D

const OBJECT_NAMES = ["banana", "cherry", "orange", "strawberry"]

func _ready():
	var random_value = randi() % (len(OBJECT_NAMES) + 1)
	if random_value == len(OBJECT_NAMES):
		set_texture(null)
	else:
		var object_name = OBJECT_NAMES[random_value]
		set_texture_string(object_name)

func set_texture_string(object_name: String):
	var texture = load("res://assets/market_tiles/food/" + object_name + ".png")
	set_texture(texture)

func set_texture(texture):
	for child in get_children():
		child.texture = texture
