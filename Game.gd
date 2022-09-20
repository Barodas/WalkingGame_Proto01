extends Node

export (PackedScene) var start_scene
export (PackedScene) var journey_planner_scene

var current_scene

func unload_current_scene():
	if current_scene:
		current_scene.queue_free()

func load_start():
	unload_current_scene()
	
	current_scene = start_scene.instance()
	add_child(current_scene)
	var button = current_scene.get_node("JourneyPlannerButton")
	button.connect("pressed", self, "_on_Journey_Planner_Button_pressed")


func load_journey_planner():
	unload_current_scene()
	
	current_scene = journey_planner_scene.instance()
	add_child(current_scene)
	var button = current_scene.get_node("UIPanel/Return")
	button.connect("pressed", self, "_on_Return_Button_pressed")


func _ready():
	load_start()


func _on_Journey_Planner_Button_pressed():
	load_journey_planner()


func _on_Return_Button_pressed():
	load_start()
