extends Control
tool

var editor_overwatch;
onready var Log = get_node("/root/GDLog");


var reset_button;

func _ready():
	reset_button = get_node("Reset");
	reset_button.connect("button_up", self, "on_reset_pressed");
	pass

func on_reset_pressed():
	reset_plugins();
	pass
	
func reset_plugins():
	reset_wayfarer_core_plugin();
	pass
	
func reset_wayfarer_core_plugin():
	var interface = editor_overwatch.get_editor_interface();
	interface.set_plugin_enabled("Wayfarer", false);
	Log.Print("wayfarer disabled", true);
	remove_old_controls();
	interface.set_plugin_enabled("Wayfarer", true);
	#print("wayfarer enabled", true)
	pass
	
func remove_old_controls():
	var interface = editor_overwatch.get_editor_interface();
	var base = interface.get_base_control();
	var editor_bar = base.find_node("EditorMenuBar", true, false);
	editor_bar.queue_free();
	pass
	
func set_overwatch(var overwatch):
	editor_overwatch = overwatch;
	pass