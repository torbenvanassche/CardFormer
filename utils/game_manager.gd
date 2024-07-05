
class_name Manager
extends Node

static var instance: Manager;
static var debug: bool = true;

var current_save_file: SaveFile;
var scroll_in_use: bool = false;

func _enter_tree():
	if not Manager.debug:
		print("Debug mode is set to " + str(debug) + ", some messages may not be shown.")
	Manager.instance = self;
	
func pause(pause_game = !get_tree().paused):
	get_tree().paused = pause_game
	if pause_game:
		SceneManager.instance.set_active_scene("pause", SceneConfig.new(false));

static func debug_log(s: String):
	if debug:
		print(s);
		
static func debug_warn(s: String):
	if debug:
		push_warning(s);
		
static func debug_err(s: String):
	if debug:
		printerr(s);
