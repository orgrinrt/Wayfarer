extends WayfarerSettings
tool

var installed_modules : Array; # array of module_meta.gd resources

func _get_property_list():
	var list := [];
	
	list.append({usage = PROPERTY_USAGE_CATEGORY, type = TYPE_NIL, name = "Project"});
	
	var text = "Here are the Project Settings for Wayfarer.";
	var text2 = "You're not able to change the settings directly via this resource. You can change the settings via the Settings Window.";
	var text3 = "Note: You can edit the wfmodule meta directly by pressing the resource";
	
	list.append({name="textbox", type=TYPE_NIL, hint_string=text});
	list.append({name="textbox", type=TYPE_NIL, hint_string=text2});
	list.append({name="modules/textbox", type=TYPE_NIL, hint_string=text3});
	
	var curr_property = {};
	for module in installed_modules:
		var name : String = "modules/installed/" + module.name;
		curr_property = {type = TYPE_OBJECT, name = name, hint = PROPERTY_HINT_RESOURCE_TYPE};
		list.append(curr_property);
	
	return list;

func _set(property, value):
	pass

func _get(property : String):
	if property.begins_with("modules/installed"):
		for module in installed_modules:
			if property == "modules/installed/" + module.name:
				return module;
	pass

func get_installed_modules() -> Array:
	return installed_modules;
	
#func get_enabled_modules() -> Array:
#	var enabled : Array;
#	
#	for module in installed_modules:
#		
	
#func get_disabled_modules() -> Array:
#	var disabled : Array;
#	
#	for module in installed_modules:
#		if

#func is_module_enabled(var name : String) -> bool:
#	for module in enabled_modules:
#		
#		

func add_installed_module(var module : WayfarerModuleMeta) -> void:
	if installed_modules.has(module):
		pass
	else:
		installed_modules.append(module);
	pass
	
func remove_installed_module(var module : WayfarerModuleMeta) -> void:
	if installed_modules.has(module):
		installed_modules.remove(installed_modules.find(module));
	else:
		pass
	pass

func set_installed_modules(var array : Array) -> void:
	installed_modules = array;
	pass