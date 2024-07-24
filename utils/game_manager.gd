extends Node
class_name Manager

var player: PlayerController;
var camera_controller: CameraController;

static var instance: Manager;
@export var orphan_timers: Node;

var in_combat: bool = false;
var battle_handler: BattleHandler;
var game_loaded_timestamp: Dictionary;

var current_save_file: SaveFile;
var scroll_in_use: bool = false;

func _init():
	Manager.instance = self;
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _unhandled_input(event):
	if event.is_action_pressed("cancel") && SceneManager.instance.node_to_info(SceneManager.instance.active_scene).id == "main_game":
		get_viewport().set_input_as_handled()
		pause();
		
func pause(pause_game = !get_tree().paused):
	get_tree().paused = pause_game
	if pause_game:
		SceneManager.instance.set_active_scene("paused", SceneConfig.new(false));
		
func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		var btn = get_viewport().gui_get_focus_owner();
		if btn is Button:
			btn.pressed.emit();
