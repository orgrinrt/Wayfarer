extends Node

const FILTER_DEFAULT = ["*"]
const FILTER_MODULE_META = ["wfmodule.tres"]
const FILTER_PEBBLE = ["*.pebble"]
const FILTER_PEBBLER = ["*.pebbler"]
const FILTER_RES = ["*.tres"]
const FILTER_SCENE = ["*.tscn"]

var plugin : EditorPlugin = null;
var filesystem : EditorFileSystem = null;

func get_files_from_dir(path, return_path = true, filter = FILTER_DEFAULT, expect_empties = true) -> Array:
	var files : Array = [];
	
	if !is_instance_valid(filesystem):
		push_error("filesystem was null");
		return files
		
	var dir = filesystem.get_filesystem_path(path)
	if !is_instance_valid(dir):
		if (dir == null):
			push_error("filesystem.get_filesystem_path returned an invalid instance");
			return files
		else:
			Log.Wf.Print("...but it was not null so it probably is valid", true);

	var file_count = dir.get_file_count();
	
	if !expect_empties:
		if file_count < 1:
			push_error("dir.get_file_count() was less than 1");
	
	for i in file_count:
		var file = dir.get_file(i)

		if _match_name(file, filter):
			if return_path:
				files.append(dir.get_file_path(i));
			else:
				files.append(file)
	return files

func get_dirs(path, return_path = true, filter = FILTER_DEFAULT, expect_empties = true):
	var dirs : Array = [];
	
	if !is_instance_valid(filesystem):
		push_error("filesystem was null");
		return dirs
	
	var dir = filesystem.get_filesystem_path(path)
	if !is_instance_valid(dir):
		if (dir == null):
			push_error("filesystem.get_filesystem_path returned an invalid instance");
			return dirs
		else:
			Log.Wf.Print("...but it was not null so it probably is valid", true);

	var subdir_count = dir.get_subdir_count();
	
	if !expect_empties:
		if subdir_count < 1:
			push_error("dir.get_subdir_count() was less than 1");
	
	for i in subdir_count:
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
	
	for file_in_root in get_files_from_dir(path, true, filter, true):
			files.append(file_in_root);

	for sub_dir in get_dirs(path, true, FILTER_DEFAULT, true):
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
	
	if (filesystem == null || !is_instance_valid(filesystem)):
		push_error("filesystem was null even after setting plugin!");
