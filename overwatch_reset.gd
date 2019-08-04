tool
extends Node

var _interface;

var Log = preload("res://Addons/Wayfarer/GDInterfaces/log.gd");

func _ready():
	pass 

func _process(delta):
	
	if (_interface.is_plugin_enabled("Wayfarer")):
		_interface.set_plugin_enabled("Wayfarer", false);
		Log.Wf.Print("Wayfarer (system base) disabled", true);
		
	if (!_interface.is_plugin_enabled("Wayfarer")):
		_interface.set_plugin_enabled("Wayfarer", true);
		Log.Wf.Print("Wayfarer (system base) enabled", true);
		queue_free();
	pass

func set_interface(var interface):
	_interface = interface;
	pass