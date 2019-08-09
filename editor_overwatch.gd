extends EditorPlugin
tool

var top_right_panel;
var wayfarer_menu;
var wayfarer_inspector;
var original_build_button;

var Log;
var Helpers;
var Utils;
var Meta : WayfarerMeta;
var Settings : WayfarerSettings;

func _enter_tree() -> void:
	Log = load("res://Addons/Wayfarer/GDInterfaces/log.gd").new();
	Helpers = load("res://Addons/Wayfarer/GDInterfaces/helpers.gd").new();
	Utils = load("res://Addons/Wayfarer/file_utils.gd").new();
	Meta = load("res://Addons/Wayfarer/Data/meta.tres");
	Settings = load("res://wfsettings.tres");
	
	Helpers.initialize_statics();
	Utils.set_plugin(self);
	pass
	
func _ready() -> void:
	var elog : RichTextLabel = get_editor_log_text();
	elog.text = "";
	
	_remove_resetter();
	_add_custom_controls();
	_update_installed_modules_list();
	top_right_panel.connect("build_pressed", self, "_on_build_pressed");
	top_right_panel.connect("reset_pressed", self, "_on_reset_pressed");
	top_right_panel.connect("reset_ow_pressed", self, "_on_reset_ow_pressed");
	
	if Settings.reset_on_ready:
		call_deferred("_on_reset_ow_pressed");
	else:
		call_deferred("_on_reset_pressed");
	pass
	
func _exit_tree() -> void:
	Helpers.dispose_statics();
	_remove_custom_controls();
	
	Log.queue_free();
	Helpers.queue_free();
	Utils.queue_free();
	
	pass

func _add_custom_controls() -> void:
	var top_right_scene = load("res://Addons/Wayfarer/Assets/Scenes/Controls/TopRightPanel.tscn");
	top_right_panel = top_right_scene.instance();
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, top_right_panel);
	original_build_button = get_original_build_button();
	original_build_button.hide();
	
	var top_menu = get_top_menu_root();
	if (is_instance_valid(top_menu)):
		var menu_scene = load("res://Addons/Wayfarer/Assets/Scenes/Controls/WayfarerMenu.tscn");
		if (is_instance_valid(menu_scene)):
			wayfarer_menu = menu_scene.instance();
			var scene_button : Control = top_menu.get_child(0);
			var style = scene_button.get("custom_styles/hover");
			if is_instance_valid(style):
				wayfarer_menu.set("custom_styles/hover", style);
			top_menu.add_child(wayfarer_menu);
		else:
			Log.Wf.Print("The WayfarerMenu scene was not valid!", true);
			
	wayfarer_inspector = load("res://Addons/Wayfarer/Inspector/inspector.gd").new();
	add_inspector_plugin(wayfarer_inspector);
	pass

func _remove_custom_controls() -> void:
	remove_inspector_plugin(wayfarer_inspector);
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, top_right_panel);
	top_right_panel.queue_free();
	
	var top_menu = get_top_menu_root();
	if (is_instance_valid(top_menu)):
		if (is_instance_valid(wayfarer_menu)):
			top_menu.remove_child(wayfarer_menu);
			wayfarer_menu.queue_free();
		else:
			Log.Wf.Print("The Wayfarer Menu instance was not valid!", true);
	else:
		Log.Wf.Print("The Top Menu instance was not valid!", true);
	
	original_build_button.show();
	pass
	
func disable_plugins() -> Array:
	var result: Array;
	var interface = get_editor_interface();
	
	result.append(interface.is_plugin_enabled("Wayfarer.Core"));
	result.append(interface.is_plugin_enabled("Wayfarer.Editor"));
	result.append(interface.is_plugin_enabled("Wayfarer.Editor.Explorer"));
	result.append(interface.is_plugin_enabled("Wayfarer.UI"));
	result.append(interface.is_plugin_enabled("Wayfarer.Editor.Taskmaster"));
	result.append(interface.is_plugin_enabled("Wayfarer.Pebbles"));
		
	# NOTE: Reverse order than in enabling - the most important last
	_disable_pebbles_plugin();
	_disable_taskmaster_plugin();
	_disable_ui_core_plugin();
	_disable_explorer_plugin();
	_disable_editor_plugin();
	_disable_wayfarer_core_plugin();
	#Helpers.dispose_statics();
	return result;
	
func enable_plugins(var state: Array) -> void:
	if (state[0]):
		_enable_wayfarer_core_plugin();
	if (state[1]):
		_enable_editor_plugin();
	if (state[2]):
		_enable_explorer_plugin();
	if (state[3]):
		_enable_ui_core_plugin();
	if (state[4]):
		_enable_taskmaster_plugin();
	if (state[5]):
		_enable_pebbles_plugin();
		
	state.clear();
	pass
	
func enable_plugins_and_reset_ow(var state: Array) -> void:
	enable_plugins(state);
	_on_reset_ow_pressed();
	pass
	
func reset_plugins():
	var state = disable_plugins();
	#ensure_iterator_is_gone();
	call_deferred("enable_plugins", state);
	pass
	
func _disable_wayfarer_core_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.Core")):
		interface.set_plugin_enabled("Wayfarer.Core", false);
		Log.Wf.Print("Wayfarer.Core disabled", true);
	pass
	
func _enable_wayfarer_core_plugin():
	var interface = get_editor_interface();
	
	if (!interface.is_plugin_enabled("Wayfarer.Core")):
		interface.set_plugin_enabled("Wayfarer.Core", true);
		Log.Wf.Print("Wayfarer.Core enabled", true);
	pass
	
func _disable_ui_core_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.UI")):
		interface.set_plugin_enabled("Wayfarer.UI", false);
		Log.Wf.Print("Wayfarer.UI disabled", true);
	pass
	
func _enable_ui_core_plugin():
	var interface = get_editor_interface();
	
	if (!interface.is_plugin_enabled("Wayfarer.UI")):
		interface.set_plugin_enabled("Wayfarer.UI", true);
		Log.Wf.Print("Wayfarer.UI enabled", true);
	pass
	
func _disable_pebbles_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.Pebbles")):
		interface.set_plugin_enabled("Wayfarer.Pebbles", false);
		Log.Wf.Print("Wayfarer.Pebbles disabled", true);
	pass
	
func _enable_pebbles_plugin():
	var interface = get_editor_interface();
	
	if (!interface.is_plugin_enabled("Wayfarer.Pebbles")):
		interface.set_plugin_enabled("Wayfarer.Pebbles", true);
		Log.Wf.Print("Wayfarer.Pebbles enabled", true);
	pass
	
func _disable_editor_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.Editor")):
		interface.set_plugin_enabled("Wayfarer.Editor", false);
		Log.Wf.Print("Wayfarer.Editor disabled", true);
	pass
	
func _enable_editor_plugin():
	var interface = get_editor_interface();
	
	if (!interface.is_plugin_enabled("Wayfarer.Editor")):
		interface.set_plugin_enabled("Wayfarer.Editor", true);
		Log.Wf.Print("Wayfarer.Editor enabled", true);
	pass
	
func _disable_explorer_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.Editor.Explorer")):
		interface.set_plugin_enabled("Wayfarer.Editor.Explorer", false);
		Log.Wf.Print("Wayfarer.Editor.Explorer disabled", true);
	pass
	
func _enable_explorer_plugin():
	var interface = get_editor_interface();
	
	if (!interface.is_plugin_enabled("Wayfarer.Editor.Explorer")):
		interface.set_plugin_enabled("Wayfarer.Editor.Explorer", true);
		Log.Wf.Print("Wayfarer.Editor.Explorer enabled", true);
	pass
	
func _disable_taskmaster_plugin():
	var interface = get_editor_interface();
	
	if (interface.is_plugin_enabled("Wayfarer.Editor.Taskmaster")):
		interface.set_plugin_enabled("Wayfarer.Editor.Taskmaster", false);
		Log.Wf.Print("Wayfarer.Editor.Taskmaster disabled", true);
	pass
	
func _enable_taskmaster_plugin():
	var interface = get_editor_interface();
	
	if (!interface.is_plugin_enabled("Wayfarer.Editor.Taskmaster")):
		interface.set_plugin_enabled("Wayfarer.Editor.Taskmaster", true);
		Log.Wf.Print("Wayfarer.Editor.Taskmaster enabled", true);
	pass
	
func custom_build():
	var state = disable_plugins();
	
	#yield(get_tree().create_timer(0.5), "timeout") # we need to be sure everything's free'd before continuing... maybe there's a better way?
	
	#ensure_iterator_is_gone();
	
	var root = get_tree().get_root();
	var editor_base = root.get_node("EditorNode");
	var godotsharpeditor = editor_base.get_node("GodotSharpEditor");
	print("didn't get past _build_solution_pressed");
	godotsharpeditor.call("_build_solution_pressed");
	print("got past _build_solution_pressed");
	#yield(get_tree().create_timer(2.0), "timeout") # we need to be sure that the build process is finished... we need a better way for this
	#enable_plugins(state);
	call_deferred("enable_plugins_and_reset_ow", state);
	pass

func _on_build_pressed():
	custom_build();
	pass
	
func _on_reset_pressed():
	reset_plugins();
	pass
	
func _on_reset_ow_pressed():
	var resetter = load("res://Addons/Wayfarer/overwatch_reset.gd");
	var instance = resetter.new();
	
	var interface = get_editor_interface();
	instance.set_interface(interface);
	instance.name = "Resetter";
	var base = interface.get_base_control();
	base.add_child(instance);
	pass
	
func _remove_resetter():
	var interface = get_editor_interface();
	var base = interface.get_base_control();
	var children = base.get_children();
	var resetter = null;
	
	for child in children:
		if (child.name == "Resetter" || child.name == "Resetter2"):
			if (is_instance_valid(child)):
				resetter = child;
				#resetter.call_deferred("queue_free");
				
	if resetter == null:
		set_reset_on_ready(true);
		print(" --- Resetter was null, ResetOnReady = true");
	else:
		set_reset_on_ready(false);
		print(" --- Resetter existed, ResetOnReady = false");
	pass
	
func get_original_build_button() -> Button:
	var base = get_editor_interface().get_base_control();
	var all = Helpers.get_children_recursive(base);
	
	for child in all:
		if (child is Button):
			if (child.text == "Build"):
				original_build_button = child;
				return child;
	return null;
	
func get_top_menu_root() -> Control:
	var base = get_editor_interface().get_base_control();
	var all = Helpers.get_children_recursive(base);
	
	for child in all:
		if (child is Button):
			if (child.text == "Help"):
				return child.get_parent();
				
	return null;
	pass
	
func get_editor_log_text() -> RichTextLabel:
	var base = get_editor_interface().get_base_control();
	var all = Helpers.get_children_recursive(base);
	
	for child in all:
		if (child is Button):
			if (child.text == "Clear"):
				return child.get_parent().get_parent().get_child(1);
				
	return null;
	pass
	
func _update_installed_modules_list() -> void:
	var addons : Array = Utils.get_dirs("res://Addons");
	var names : Array = Utils.get_dirs("res://Addons", false);
	var i = 0;
	
	Settings.set_installed_modules([]);
	
	for dir_path in addons:
		var metas = Utils.get_files_recursive(dir_path, Utils.FILTER_MODULE_META);
		if (metas.size() > 1):
			Log.Wf.Print("FOUND MULTIPLE WAYFARE MODULE META FILES WITHIN ADDON", true);
			for module in metas:
				print(module);
		elif (metas.size() == 1):
			Settings.add_installed_module(load(metas[0]));
			Log.Wf.Print("ADDED INSTALLED MODULE " + dir_path, true);
		else:
			Log.Wf.Print("FOUND NO META FILES FOR ADDON " + dir_path, true);
			if names[i].begins_with("Wayfarer"):
				Log.Wf.Print("          ...but we might want to create one now", true);
		i += 1;
	pass
	
func set_reset_on_ready(value : bool) -> void:
	Settings.reset_on_ready = value;
	pass