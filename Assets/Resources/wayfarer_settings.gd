extends Resource
class_name WayfarerSettings
tool

export var installed_modules : Array; # array of module_meta.gd resources

export var settings : Dictionary; # key = string setting_path, value = value

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