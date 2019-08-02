extends EditorPlugin
tool

var top_right_panel;
var original_build_button;

onready var Log = load("res://Addons/Wayfarer.Core/GDInterfaces/log.gd");
onready var Helpers = load("res://Addons/Wayfarer.Core/GDInterfaces/helpers.gd");

func _enter_tree() -> void:
	remove_resetter();
	pass
	
func _ready() -> void:
	add_custom_controls();
	top_right_panel.connect("build_pressed", self, "on_build_pressed");
	top_right_panel.connect("reset_pressed", self, "on_reset_pressed");
	top_right_panel.connect("reset_ow_pressed", self, "on_reset_ow_pressed");
	
	call_deferred("reset_plugins");
	pass
	
func _exit_tree() -> void:
	remove_custom_controls();
	pass

func add_custom_controls() -> void:
	var top_right_scene = load("res://Addons/Wayfarer/Assets/Scenes/Controls/TopRightPanel.tscn");
	top_right_panel = top_right_scene.instance();
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, top_right_panel);
	original_build_button = get_original_build_button();
	original_build_button.hide();
	pass

func remove_custom_controls() -> void:
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, top_right_panel);
	top_right_panel.queue_free();
	original_build_button.show();
	pass
	
func disable_plugins() -> Array:
	var result: Array;
	var interface = get_editor_interface();
	
	result.append(interface.is_plugin_enabled("Wayfarer.Core"));
	result.append(interface.is_plugin_enabled("Wayfarer.Editor"));
	result.append(interface.is_plugin_enabled("Wayfarer.Editor.Explorer"));
	result.append(interface.is_plugin_enabled("Wayfarer.Pebbles"));
		
	# NOTE: Reverse order than in enabling - the most important last
	disable_pebbles_plugin();
	disable_explorer_plugin();
	disable_editor_plugin();
	disable_wayfarer_core_plugin();
	return result;
	
func enable_plugins(var state: Array) -> void:
	if (state[0]):
		enable_wayfarer_core_plugin();
	if (state[1]):
		enable_editor_plugin();
	if (state[2]):
		enable_explorer_plugin();
	if (state[3]):
		enable_pebbles_plugin();
		
	state.clear();
	pass
	
func reset_plugins():
	var state = disable_plugins();
	ensure_iterator_is_gone();
	call_deferred("enable_plugins", state);
	pass
	
func disable_wayfarer_core_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.Core")):
		interface.set_plugin_enabled("Wayfarer.Core", false);
		Log.Wf.Print("Wayfarer.Core disabled", true);
	pass
	
func enable_wayfarer_core_plugin():
	var interface = get_editor_interface();
	
	if (!interface.is_plugin_enabled("Wayfarer.Core")):
		interface.set_plugin_enabled("Wayfarer.Core", true);
		Log.Wf.Print("Wayfarer.Core enabled", true);
	pass
	
func disable_pebbles_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.Pebbles")):
		interface.set_plugin_enabled("Wayfarer.Pebbles", false);
		Log.Wf.Print("Wayfarer.Pebbles disabled", true);
	pass
	
func enable_pebbles_plugin():
	var interface = get_editor_interface();
	
	if (!interface.is_plugin_enabled("Wayfarer.Pebbles")):
		interface.set_plugin_enabled("Wayfarer.Pebbles", true);
		Log.Wf.Print("Wayfarer.Pebbles enabled", true);
	pass
	
func disable_editor_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.Editor")):
		interface.set_plugin_enabled("Wayfarer.Editor", false);
		Log.Wf.Print("Wayfarer.Editor disabled", true);
	pass
	
func enable_editor_plugin():
	var interface = get_editor_interface();
	
	if (!interface.is_plugin_enabled("Wayfarer.Editor")):
		interface.set_plugin_enabled("Wayfarer.Editor", true);
		Log.Wf.Print("Wayfarer.Editor enabled", true);
	pass
	
func disable_explorer_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.Editor.Explorer")):
		interface.set_plugin_enabled("Wayfarer.Editor.Explorer", false);
		Log.Wf.Print("Wayfarer.Editor.Explorer disabled", true);
	pass
	
func enable_explorer_plugin():
	var interface = get_editor_interface();
	
	if (!interface.is_plugin_enabled("Wayfarer.Editor.Explorer")):
		interface.set_plugin_enabled("Wayfarer.Editor.Explorer", true);
		Log.Wf.Print("Wayfarer.Editor.Explorer enabled", true);
	pass
	
func custom_build():
	var state = disable_plugins();
	
	#yield(get_tree().create_timer(0.5), "timeout") # we need to be sure everything's free'd before continuing... maybe there's a better way?
	
	ensure_iterator_is_gone();
	
	var root = get_tree().get_root();
	var editor_base = root.get_node("EditorNode");
	var godotsharpeditor = editor_base.get_node("GodotSharpEditor");
	
	godotsharpeditor.call("_build_solution_pressed");
	
	#yield(get_tree().create_timer(2.0), "timeout") # we need to be sure that the build process is finished... we need a better way for this
	#enable_plugins(state);
	call_deferred("enable_plugins", state);
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
	
func ensure_iterator_is_gone():
	Log.Wf.Print("Ensuring the EditorIterator is gone...", true);
	"""
	var interface = get_editor_interface();
	#if (interface.is_plugin_enabled("Wayfarer.Editor")):
	var iterator = get_editor_interface().get_base_control().get_node("EditorIterator");
	var iterator2 = get_editor_interface().get_base_control().get_node("EditorIterator2");
	if (is_instance_valid(iterator)):
		iterator.queue_free();
		Log.Wf.Print("The Iterator instance queued free, we OK", true);
		ensure_iterator_is_gone();
	else:
		Log.Wf.Print("The Iterator instance wasn't valid, trying alt name...", true);
		if (is_instance_valid(iterator2)):
			iterator2.queue_free();
			Log.Wf.Print("The Iterator instance queued free, we OK (alt name)", true);
			ensure_iterator_is_gone();
		else:
			print("Nothing happened");
			return"""
	pass