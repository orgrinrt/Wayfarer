extends EditorPlugin
tool

var top_right_panel;
var original_build_button;

onready var Log = load("res://Addons/Wayfarer.Core/GDInterfaces/log.gd");
onready var Helpers = load("res://Addons/Wayfarer.Core/GDInterfaces/helpers.gd");

func _enter_tree():
	remove_resetter();
	pass
	
func _ready():
	add_custom_controls();
	top_right_panel.connect("build_pressed", self, "on_build_pressed");
	top_right_panel.connect("reset_pressed", self, "on_reset_pressed");
	top_right_panel.connect("reset_ow_pressed", self, "on_reset_ow_pressed");
	
	call_deferred("reset_plugins");
	pass
	
func _exit_tree():
	remove_custom_controls();
	pass

func add_custom_controls():
	var top_right_scene = load("res://Addons/Wayfarer/Assets/Scenes/Controls/TopRightPanel.tscn");
	top_right_panel = top_right_scene.instance();
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, top_right_panel);
	original_build_button = get_original_build_button();
	original_build_button.hide();
	pass

func remove_custom_controls():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, top_right_panel);
	top_right_panel.queue_free();
	original_build_button.show();
	pass
	
func reset_plugins():
	reset_wayfarer_core_plugin();
	reset_pebbles_plugin();
	reset_explorer_plugin();
	pass
	
func reset_wayfarer_core_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.Core")):
		interface.set_plugin_enabled("Wayfarer.Core", false);
		Log.Wf.Print("Wayfarer.Core disabled", true);
		interface.set_plugin_enabled("Wayfarer.Core", true);
		Log.Wf.Print("Wayfarer.Core enabled", true);
	pass
	
func reset_pebbles_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.Pebbles")):
		interface.set_plugin_enabled("Wayfarer.Pebbles", false);
		Log.Wf.Print("Wayfarer.Pebbles disabled", true);
		interface.set_plugin_enabled("Wayfarer.Pebbles", true);
		Log.Wf.Print("Wayfarer.Pebbles enabled", true);
	pass
	
func reset_explorer_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.Editor.Explorer")):
		interface.set_plugin_enabled("Wayfarer.Editor.Explorer", false);
		Log.Wf.Print("Wayfarer.Editor.Explorer disabled", true);
		interface.set_plugin_enabled("Wayfarer.Editor.Explorer", true);
		Log.Wf.Print("Wayfarer.Editor.Explorer enabled", true);
	pass
	
func custom_build():
	var root = get_tree().get_root();
	var editor_base = root.get_node("EditorNode");
	var godotsharpeditor = editor_base.get_node("GodotSharpEditor");
	
	godotsharpeditor.call("_build_solution_pressed");
	
	call_deferred("on_reset_pressed");
	pass

func on_build_pressed():
	custom_build();
	pass
	
func on_reset_pressed():
	reset_plugins();
	pass
	
func on_reset_ow_pressed():
	var resetter = load("res://Addons/Wayfarer/overwatch_reset.gd");
	var instance = resetter.new();
	
	var interface = get_editor_interface();
	instance.set_interface(interface);
	instance.name = "Resetter";
	var base = interface.get_base_control();
	base.add_child(instance);
	pass
	
func remove_resetter():
	var interface = get_editor_interface();
	var base = interface.get_base_control();
	var resetter = base.get_node("Resetter");
	if (resetter != null):
		resetter.queue_free();
	pass
	
func get_original_build_button():
	var base = get_editor_interface().get_base_control();
	var all = Helpers.get_children_recursive(base);
	
	for child in all:
		if (child is Button):
			if (child.text == "Build"):
				original_build_button = child;
				return child;
	pass