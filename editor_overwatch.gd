extends EditorPlugin
tool

var top_right_panel;

func _enter_tree():
	add_custom_controls();
	pass
	
func _exit_tree():
	remove_custom_controls();
	pass

func add_custom_controls():
	#remove_old_topright_bar();
	var top_right_scene = load("res://Addons/Wayfarer.Overwatch/Assets/Scenes/Controls/TopRightPanel.tscn");
	top_right_panel = top_right_scene.instance();
	top_right_panel.set_overwatch(self);
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, top_right_panel);

	pass

func remove_custom_controls():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, top_right_panel);
	top_right_panel.queue_free();
	pass
	
#func remove_old_topright_bar():
#	pass