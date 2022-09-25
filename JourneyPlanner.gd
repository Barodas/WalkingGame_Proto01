extends CanvasLayer

export (PackedScene) var path_node_scene
export (PackedScene) var journey_file_button_scene

signal set_journey(map_texture, journey)

var is_tracking = false
var mouse_position
var hovered_node

var node_list = []
var journey_file_list = []

var loaded_map_texture
var loaded_journey = []

var preview_selected_journey

func save(data):
	var file = File.new()
	var datetime = Time.get_datetime_string_from_system()
	datetime = datetime.replace(":", "")
	var file_name = "user://journey_" + datetime + ".json"
	file.open(file_name, File.WRITE)
	file.store_line(to_json(data))
	file.close()
	print("File saved to: ", file_name)


func load_journey_list():
	for file in journey_file_list:
		file.queue_free()
	journey_file_list.clear()
	
	var files = []
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file.begins_with("journey_"):
			files.append(file)
		if file == "":
			break
	
	dir.list_dir_end()
	
	for file in files:
		var button = journey_file_button_scene.instance()
		button.initialise(file)
		journey_file_list.push_back(button)
		$UIPanel/ScrollContainer/VBoxContainer.add_child(button)
		button.connect("file_selected", self, "_on_File_Selected")
	
	# TODO: Selecting a journey should display it on the map
	# TODO: Send selected map to game
	# TODO: Clear indication of selected journey


func load_map():
	var file
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin()
	
	while true:
		file = dir.get_next()
		if file.begins_with("map_"):
			break
		if file == "":
			break
	
	dir.list_dir_end()
	
	var file_path = "user://" + file
	var image = Image.new()
	var error = image.load(file_path)
	if error != OK:
		print("ERROR: Failed to load map")
		return
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	$Map.texture = texture
	loaded_map_texture = texture
	$UIPanel/MapLabel.text = file


func set_journey():
	# TODO: Check for invalid map/journey
	emit_signal("set_journey", loaded_map_texture, loaded_journey)
	show_preview()


func show_preview():
	if node_list.size() > 0:
		remove_nodes(node_list.front())
	
	for position in loaded_journey:
		var node = path_node_scene.instance()
#		node.connect("hover_enter", self, "_on_PathNode_hover_enter")
#		node.connect("hover_exit", self, "_on_PathNode_hover_exit")
		node.get_node("ColorRect").visible = false
		node.position = position
		if !node_list.empty():
			node.set_line(node_list.back().position)
		node_list.push_back(node)
		add_child(node)


func _ready():
	load_map()
	load_journey_list()


func _process(_delta):
	# Complete path if left clicking first node
#	if Input.is_action_pressed("click_left") and hovered_node != null:
#		if hovered_node == node_list.first():
#			pass
	
	# Remove hovered node
	if Input.is_action_pressed("click_right") and hovered_node != null:
		remove_nodes(hovered_node)
		hovered_node = null


func remove_nodes(target_node):
	print("Removing Hovered Node")
	var target_index = node_list.find(target_node)
	var node_list_size = node_list.size()
	for _i in range(node_list_size, target_index, -1):
		var node = node_list.pop_back()
		node.queue_free()
	print("Removed ", node_list_size - target_index, " Nodes")


func _on_CreateJourney_pressed():
	if is_tracking == true:
		return
	
	is_tracking = true
	print("Start Tracking!")


func _on_FinishJourney_pressed():
	if is_tracking == false:
		return
	
	is_tracking = false
	print("Stop Tracking!")
	
	var node_positions = []
	for node in node_list:
		loaded_journey.push_back(node.position)
		node_positions.push_back({
			"x" : node.position.x,
			"y" : node.position.y
			})
	
	var output = {
		"time" : $UIPanel/TimeInput.text,
		"nodes" : node_positions
	}
	save(output)
	
	remove_nodes(node_list.front())
	set_journey()
	load_journey_list()


func _on_Map_gui_input(event):
	if is_tracking == false:
		return
	
	if event is InputEventMouse:
		mouse_position = event.position
	
	if event is InputEventMouseButton and event.is_pressed():
		if event.get_button_index() == BUTTON_LEFT:
			var node = path_node_scene.instance()
			node.connect("hover_enter", self, "_on_PathNode_hover_enter")
			node.connect("hover_exit", self, "_on_PathNode_hover_exit")
			node.position = mouse_position
			if !node_list.empty():
				node.set_line(node_list.back().position)
			node_list.push_back(node)
			add_child(node)


func _on_PathNode_hover_enter(hovered):
	print("node hover enter")
	hovered_node = hovered


func _on_PathNode_hover_exit(_hovered):
	print("node hover exit")
	hovered_node = null


func _on_TimeInput_text_changed():
	pass # TODO: Validate input is valid HH:MM Time


func _on_Refresh_pressed():
	load_journey_list()


func _on_LoadMap_pressed():
	load_map()


func _on_File_Selected(name):
	if is_tracking == true:
		return
	
	# TODO: Load time and pass to game as well
	
	var file_name = "user://" + name
	var file = File.new()
	if not file.file_exists(file_name):
		return
	file.open(file_name, File.READ)
	var data = parse_json(file.get_as_text())
	var nodes = []
	for node in data.nodes:
		nodes.push_back(Vector2(node.x, node.y))
	loaded_journey = nodes
	
	set_journey()

