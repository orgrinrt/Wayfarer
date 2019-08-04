extends MenuButton
tool

var show_missing;

func _ready() -> void:
	var popup : PopupMenu = get_popup();
	
	popup.clear();
	popup.rect_min_size.x = 225;
	
	var settings = popup.add_item("Settings");
	popup.add_separator();
	
	var show_missing = popup.add_check_item("Show Missing");
	popup.add_separator();
	
	pass 
