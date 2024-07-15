
class_name Manager
extends Node

static var instance: Manager;

var player: PlayerController;
var in_combat: bool = false;
var battle_handler: BattleHandler;

var current_save_file: SaveFile;
var scroll_in_use: bool = false;

func _enter_tree():
	if not Debug.show_log:
		Debug.message("Debug mode is set to " + str(Debug.show_log) + ", some messages may not be shown.")
	Manager.instance = self;
	
func pause(pause_game = !get_tree().paused):
	get_tree().paused = pause_game
	if pause_game:
		SceneManager.instance.set_active_scene("pause", SceneConfig.new(false));
