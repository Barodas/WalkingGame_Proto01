extends CanvasLayer



func load_journey_list():
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
	
	


func _on_Map_gui_input(event):
	pass # Replace with function body.
