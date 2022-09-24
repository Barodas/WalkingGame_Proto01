extends Node

export (PackedScene) var start_scene
export (PackedScene) var journey_planner_scene
export (PackedScene) var expedition_scene

var current_scene
var current_map_texture
var current_journey

# TODO: save/load the current map & journey to avoid setting up each run

func unload_current_scene():
	if current_scene:
		current_scene.queue_free()

func load_start():
	unload_current_scene()
	
	current_scene = start_scene.instance()
	add_child(current_scene)
	var button = current_scene.get_node("JourneyPlannerButton")
	button.connect("pressed", self, "_on_Journey_Planner_Button_pressed")
	button = current_scene.get_node("ExpeditionButton")
	button.connect("pressed", self, "_on_Expedition_Button_pressed")


func load_journey_planner():
	unload_current_scene()
	
	current_scene = journey_planner_scene.instance()
	add_child(current_scene)
	var button = current_scene.get_node("UIPanel/Return")
	button.connect("pressed", self, "_on_Return_Button_pressed")
	current_scene.connect("set_journey", self, "_on_set_journey")


func load_expedition():
	unload_current_scene()
	
	current_scene = expedition_scene.instance()
	add_child(current_scene)
	current_scene.initialise(current_map_texture, current_journey)
	var button = current_scene.get_node("UIPanel/Return")
	button.connect("pressed", self, "_on_Return_Button_pressed")


func _ready():
	load_start()


func _on_Journey_Planner_Button_pressed():
	load_journey_planner()


func _on_Expedition_Button_pressed():
	load_expedition()


func _on_Return_Button_pressed():
	load_start()


func _on_set_journey(map_texture, journey):
	current_map_texture = map_texture
	current_journey = journey

