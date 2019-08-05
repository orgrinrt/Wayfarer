extends EditorPlugin
tool

var top_right_panel;
var wayfarer_menu;
var original_build_button;

var Log = preload("res://Addons/Wayfarer/GDInterfaces/log.gd");
var Helpers = preload("res://Addons/Wayfarer/GDInterfaces/helpers.gd");
var Utils = preload("res://Addons/Wayfarer/file_utils.gd").new();
var Meta : WayfarerMeta = preload("res://Addons/Wayfarer/Data/meta.tres");
var Settings : WayfarerSettings = preload("res://wfsettings.tres");
var WayfarerInspector : WayfarerInspector = preload("res://Addons/Wayfarer/Inspector/inspector.gd").new();

func _enter_tree() -> void:
	remove_resetter();
	Utils.set_plugin(self);
	update_installed_modules_list();
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
			
	add_inspector_plugin(WayfarerInspector);
	pass

func remove_custom_controls() -> void:
	remove_inspector_plugin(WayfarerInspector);
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
	#ensure_iterator_is_gone();
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
	
	#ensure_iterator_is_gone();
	
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
	
func get_top_menu_root() -> Control:
	var base = get_editor_interface().get_base_control();
	var all = Helpers.get_children_recursive(base);
	
	for child in all:
		if (child is Button):
			if (child.text == "Help"):
				return child.get_parent();
				
	return null;
	pass
	
func update_installed_modules_list():
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