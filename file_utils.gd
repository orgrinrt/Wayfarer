extends Node

const FILTER_DEFAULT = ["*"]
const FILTER_MODULE_META = ["wfmodule.tres"]
const FILTER_PEBBLE = ["*.pebble"]
const FILTER_PEBBLER = ["*.pebbler"]
const FILTER_RES = ["*.tres"]
const FILTER_SCENE = ["*.tscn"]

var plugin : EditorPlugin;
var filesystem : EditorFileSystem;

func get_files_from_dir(path, return_path = true, filter = FILTER_DEFAULT) -> Array:
	var files : Array = [];
	
	var dir = filesystem.get_filesystem_path(path)
	if !is_instance_valid(dir):
		return files

	for i in dir.get_file_count():
		var file = dir.get_file(i)

		if _match_name(file, filter):
			if return_path:
				files.append(dir.get_file_path(i));
			else:
				files.append(file)
	return files

func get_dirs(path, return_path = true, filter = FILTER_DEFAULT):
	var dirs : Array = [];
	
	var dir = filesystem.get_filesystem_path(path)
	if !is_instance_valid(dir):
		return dirs

	for i in dir.get_subdir_count():
		var subdir = dir.get_subdir(i)
		var name = subdir.get_name()

		if _match_name(name, filter):
			if return_path:
				dirs.append(subdir.get_path());
			else:
				dirs.append(name)
	return dirs

func get_files_recursive(path, filter = FILTER_DEFAULT) -> Array:
	var files : Array = [];
	
	for file_in_root in get_files_from_dir(path, true, filter):
			files.append(file_in_root);

	for sub_dir in get_dirs(path):
		var sub_files = get_files_recursive(sub_dir, filter);
		for sub_file in sub_files:
			files.append(sub_file);
	return files

func _match_name(name : String, filter) -> bool:
	var matched = false

	for pattern in filter:
		if name.match(pattern):
			matched = true
			break

	return matched
	
func set_plugin(var p : EditorPlugin):
	plugin = p;
	filesystem = plugin.get_editor_interface().get_resource_filesystem()
