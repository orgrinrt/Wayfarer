extends Resource
class_name WayfarerSettings
tool

var settings : Dictionary; # key = string setting_path, value = dictionary of "value: x", "desc: x" etc.

func _get_property_list():
	var list := [];
	
	list.append({usage = PROPERTY_USAGE_CATEGORY, type = TYPE_NIL, name = "Settings"});
	list.append({name = "editor/textbox", type = TYPE_NIL, hint_string = "All Editor related settings can be found below."});
	
	var i : int = 0;
	var curr_property := {};
	for meta in settings.values():
		var setting_path = settings.keys()[i];
		var type_enum = TYPE_NIL;
		var value = meta["value"];
		
		if (value is bool):
			type_enum = TYPE_BOOL;
		elif (value is String):
			type_enum = TYPE_STRING;
		elif (value is int):
			type_enum = TYPE_INT;
		elif (value is float):
			type_enum = TYPE_REAL;
		elif (value is Object):
			type_enum = TYPE_OBJECT;
		elif (value is Dictionary):
			type_enum = TYPE_DICTIONARY;
		elif (value is NodePath):
			type_enum = TYPE_NODE_PATH;
		
		curr_property = {name = setting_path, type = type_enum};
		list.append(curr_property);

	return list;

func _set(property, value):
	pass

func _get(property):
	if property == "settings":
		return settings;
	pass