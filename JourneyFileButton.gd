extends ToolButton

signal file_selected(name)

var file_name

func initialise(name):
	file_name = name
	var display_name = name.replace("journey_", "")
	display_name = display_name.replace(".json", "")
	text = display_name

func _on_JourneyFileButton_pressed():
	emit_signal("file_selected", file_name)
