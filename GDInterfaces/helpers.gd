tool
extends Node

static func get_children_recursive(var node : Node) -> Array:
	var cs_bridge = load("res://Addons/Wayfarer/Utils/Gd.cs");
	var cs_instance = cs_bridge.new();
	var children = cs_instance.call("GetChildrenRecursive", node);
	cs_instance.queue_free();
	return children;
	
static func instantiate_statics() -> void:
	var cs_bridge = load("res://Addons/Wayfarer/Utils/Gd.cs");
	var cs_instance = cs_bridge.new();
	cs_instance.call("InitializeStatics");
	cs_instance.queue_free();
	print(" --- Initialized statics!");
	pass
	
static func dispose_statics() -> void:
	var cs_bridge = load("res://Addons/Wayfarer/Utils/Gd.cs");
	var cs_instance = cs_bridge.new();
	cs_instance.call("DisposeStatics");
	cs_instance.queue_free();
	print(" --- Disposed statics!");
	pass