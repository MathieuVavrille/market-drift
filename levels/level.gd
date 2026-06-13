extends Node2D

@export_range(0, 9) var level_number: int = 0

const goal_arrow_scene = preload("res://base/goal_arrow.tscn")

@export var maze_size = 0

var nb_objects = 0
var start_time = 0
func _ready():
	if maze_size != 0:
		generate_maze()
	if level_number == 9:
		$LevelEnd.deactivate_next()
	$LevelEnd.level_times = LevelTimes.load(level_number)
	nb_objects = len($Objects.get_children())
	for object in $Objects.get_children():
		object.is_achieved.connect(object_area_achieved)
		instantiate_goal_arrow(object, object.get_texture())
	get_tree().create_timer(0.01).timeout.connect(pause_at_the_start)
	$SceneChanger.start_scene()
	_on_countdown_go()

func random_list(n: int):
	var result = {}
	var positions = {}
	positions[0] = 0
	result[0] = 3
	for i in range(1, n+1):
		result[i] = randi_range(1, 3)
		result[-i] = randi_range(1, 3)
		positions[i] = positions[i-1] + result[i-1] + 1
		positions[-i] = positions[-i+1] - result[-i] - 1
	result[0] = 3
	positions[n+1] = positions[n] + result[n] + 1
	return [result, positions]

func delete_edge(startx, endx, starty, width, is_horizontal):
	for x in range(startx, endx):
		for y in range(starty, starty+width):
			if is_horizontal:
				$Market.erase_cell(Vector2i(x, y))
				$MarketObjects.erase_cell(Vector2i(x, y))
			else:
				$MarketObjects.erase_cell(Vector2i(y, x))

func generate_maze():
	var mst = MST.new(maze_size)
	var vertical_data = random_list(maze_size)
	var vertical_columns = vertical_data[0]
	var vertical_positions = vertical_data[1]
	var horizontal_data = random_list(maze_size)
	var horizontal_columns = horizontal_data[0]
	var horizontal_positions = horizontal_data[1]
	for vpi in range(-maze_size, maze_size+2):
		var vp = vertical_positions[vpi] - 1
		for hp in range(horizontal_positions[-maze_size]-1, horizontal_positions[maze_size+1]):
			$Market.set_cell(Vector2i(hp, vp), 1, Vector2i(0, 0))
			$MarketObjects.set_cell(Vector2i(hp, vp), 0, Vector2i(0, 0))
	for hpi in range(-maze_size, maze_size+2):
		var hp = horizontal_positions[hpi] - 1
		for vp in range(vertical_positions[-maze_size]-1, vertical_positions[maze_size+1]):
			$Market.set_cell(Vector2i(hp, vp), 1, Vector2i(0, 0))
			$MarketObjects.set_cell(Vector2i(hp, vp), 0, Vector2i(0, 0))
	for edge in mst.edges:
		var start_i = edge[0]
		var end = edge[1]
		if start_i[0] == end[0]:
			delete_edge(horizontal_positions[start_i[1]], horizontal_positions[end[1]], vertical_positions[start_i[0]], vertical_columns[start_i[0]], true)
		else:
			delete_edge(vertical_positions[start_i[0]], vertical_positions[end[0]], horizontal_positions[start_i[1]], horizontal_columns[start_i[1]], false)
	var factor = 10
	var start_position = Vector2(15, 14)
	$Objects/ObjectTopLeft.position = Vector2(horizontal_positions[-maze_size]-1, vertical_positions[-maze_size]-1) * factor + start_position
	$Objects/ObjectTopRight.position = Vector2(horizontal_positions[maze_size+1]-3, vertical_positions[-maze_size]-1) * factor + start_position
	$Objects/ObjectBotLeft.position = Vector2(horizontal_positions[-maze_size]-1, vertical_positions[maze_size+1]-3) * factor + start_position
	$Objects/ObjectBotRight.position = Vector2(horizontal_positions[maze_size+1]-3, vertical_positions[maze_size+1]-3) * factor + start_position
	$Registers/RegisterTop.position = Vector2(0, vertical_positions[-maze_size]-2) * factor + start_position + Vector2(5, 0)
	$Registers/RegisterBot.position = Vector2(0, vertical_positions[maze_size+1]-2) * factor + start_position + Vector2(-5, 0)
	$Registers/RegisterLeft.position = Vector2(horizontal_positions[-maze_size]-2, 0) * factor + start_position + Vector2(0, -5)
	$Registers/RegisterRight.position = Vector2(horizontal_positions[maze_size+1]-2, 0) * factor + start_position + Vector2(0, 5)
	$PlayerCart.top = $Registers/RegisterTop.position.y - 10
	$PlayerCart.bottom = $Registers/RegisterBot.position.y + 10
	$PlayerCart.left = $Registers/RegisterLeft.position.x - 10
	$PlayerCart.right = $Registers/RegisterRight.position.x + 10
	delete_edge(horizontal_positions[-maze_size]-2, horizontal_positions[-maze_size], vertical_positions[0], 2, true)
	delete_edge(horizontal_positions[maze_size], horizontal_positions[maze_size+1], vertical_positions[0]+1, 2, true)
	delete_edge(vertical_positions[-maze_size]-2, vertical_positions[-maze_size], horizontal_positions[0]+1, 2, false)
	delete_edge(vertical_positions[maze_size], vertical_positions[maze_size+1], horizontal_positions[0], 2, false)

func pause_at_the_start():
	get_tree().paused = true

const BEFORE_COUNTDOWN_TIME = 0.5
func _on_scene_changer_scene_started() -> void:
	$Countdown.start()

func _on_countdown_go() -> void:
	get_tree().paused = false
	$LevelEnd.is_started = true
	
	
func start():
	start_time = Time.get_ticks_msec()
	get_tree().paused = false
	

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		$LevelEnd.end_level(220)

func instantiate_goal_arrow(object, texture):
	var goal_arrow = goal_arrow_scene.instantiate()
	goal_arrow.camera = $PlayerCart.get_camera()
	goal_arrow.target = object
	goal_arrow.set_sprite(texture)
	goal_arrow.visible = false
	add_child(goal_arrow)

var nb_achieved = 0
func object_area_achieved():
	nb_achieved += 1
	if nb_achieved == nb_objects:
		for register in $Registers.get_children():
			register.activate()
			instantiate_goal_arrow(register.get_node("Area"), null)


func _on_register_finished() -> void:
	var total_time_ms = Time.get_ticks_msec() - start_time
	@warning_ignore("integer_division")
	SaveData.set_level_pb(level_number, total_time_ms / 100)
	@warning_ignore("integer_division")
	$LevelEnd.end_level(total_time_ms / 100)


func _on_restart() -> void:
	$SceneChanger.next_scene = load("res://levels/layouts/level_" + str(level_number) + ".tscn")
	$SceneChanger.to_next_scene()


func _on_level_end_next() -> void:
	$SceneChanger.next_scene = load("res://levels/layouts/level_" + str(level_number+1) + ".tscn")
	$SceneChanger.to_next_scene()


func _on_menu() -> void:
	$SceneChanger.next_scene = load("res://ui/menus/title_screen.tscn")
	$SceneChanger.to_next_scene()
