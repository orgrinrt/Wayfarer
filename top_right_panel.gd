extends HBoxContainer
class_name TopRightPanel
tool

signal reset_pressed;
signal build_pressed;
signal reset_ow_pressed;

#var editor_overwatch;
onready var Log = load("res://Addons/Wayfarer.Core/GDInterfaces/log.gd");

var build_button;
var reset_button;
var reset_ow_button;

func _ready():
	build_button = get_node("Build");
	build_button.connect("button_up", self, "on_build_pressed");
	
	reset_button = get_node("Reset");
	reset_button.connect("button_up", self, "on_reset_pressed");
	
	reset_ow_button = get_node("ResetOverwatch");
	reset_ow_button.connect("button_up", self, "on_reset_ow_pressed");
	pass
	
func on_build_pressed():
	emit_signal("build_pressed");
	pass

func on_reset_pressed():
	emit_signal("reset_pressed");
	pass
	
func on_reset_ow_pressed():
	emit_signal("reset_ow_pressed");
	pass

#func set_overwatch(var overwatch):
#	editor_overwatch = overwatch;
#	pass
