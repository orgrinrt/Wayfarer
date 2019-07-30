tool
extends Node

var _interface;

onready var Log = load("res://Addons/Wayfarer/GDInterfaces/log.gd");

func _ready():
	pass 

func _process(delta):
	
	if (_interface.is_plugin_enabled("Wayfarer.Overwatch")):
		_interface.set_plugin_enabled("Wayfarer.Overwatch", false);
		Log.Print("Wayfarer.Overwatch disabled", true);
		
	if (!_interface.is_plugin_enabled("Wayfarer.Overwatch")):
		_interface.set_plugin_enabled("Wayfarer.Overwatch", true);
		Log.Print("Wayfarer.Overwatch enabled, queue_free() this resetter", true);
		queue_free();
	pass

func set_interface(var interface):
	_interface = interface;
	pass