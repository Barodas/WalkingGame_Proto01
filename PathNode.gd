extends Node2D

signal hover_enter
signal hover_exit

var base_size = 10
var hover_size = 15
var line_width = 6

func set_size(value):
	$ColorRect.margin_left = -value
	$ColorRect.margin_top = -value
	$ColorRect.margin_right = value
	$ColorRect.margin_bottom = value


func set_line(target_position):
	# figure out angle and length of line to target_position
	$Line.visible = true
	$Line.set_rotation(target_position.angle_to_point(position))
	$Line.set_size(Vector2(position.distance_to(target_position), line_width))


func _ready():
	set_size(base_size)


func _on_ColorRect_mouse_entered():
	set_size(hover_size)
	emit_signal("hover_enter", self)


func _on_ColorRect_mouse_exited():
	set_size(base_size)
	emit_signal("hover_exit", self)
