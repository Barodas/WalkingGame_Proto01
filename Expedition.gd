extends CanvasLayer

var current_journey

func initialise(map_texture, journey):
	$Map.texture = map_texture
	current_journey = journey


func _on_Map_gui_input(event):
	pass # Replace with function body.

