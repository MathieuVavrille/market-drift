extends Node2D

const OBJECT_NAMES = ["banana", "cheese", "cherry", "egg", "eggplant", "grape", "leek", "lemon", "melon", "milk", "orange", "strawberry", "toilet_paper", "watermelon"]
var texture = null:
	set(value):
		texture = value
		for child in get_children():
			child.texture = texture

func _ready():
	set_random_texture(true)

func set_random_texture(can_be_null = false):
	var random_value = randi() % (len(OBJECT_NAMES) + (1 if can_be_null else 0))
	if random_value == len(OBJECT_NAMES):
		texture = null
	else:
		var object_name = OBJECT_NAMES[random_value]
		texture = load("res://assets/market_tiles/food/" + object_name + ".png")
