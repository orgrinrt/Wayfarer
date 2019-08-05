extends EditorInspectorPlugin
class_name WayfarerInspector
tool

var text_box_property;

func can_handle(object):
    # if only editing a specific type
    # return object is TheTypeIWant
    # if everything is supported
    return true

func parse_property(object, type, path : String, hint, hint_text : String, usage):
	if (path.ends_with("textbox")):
		var inspector_label = load("res://Addons/Wayfarer/Assets/Scenes/Controls/InspectorLabel.tscn");
		var instance = inspector_label.instance();
		instance.text = hint_text;
		
		add_custom_control(instance);
		#add_property_editor(path, text_box_property);
		return true # I want this one
	else:
		return false