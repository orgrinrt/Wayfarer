extends Resource
class_name WayfarerMeta
tool

var all_modules : Array; # just the names of all available modules (this ver)

func _get_property_list():
	return [
		{usage = PROPERTY_USAGE_CATEGORY, type = TYPE_NIL, name = "WayfarerMeta"},
		{type = TYPE_ARRAY, name = "global/all_modules"}
	]

func _set(property, value):
	pass

func _get(property):
	if property == "test":
		return "This is a test";
	pass