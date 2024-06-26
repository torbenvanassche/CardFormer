
class_name Manager
extends Node

static var instance: Manager;
@export var tilemap: TileMap;
var camera: Camera2D;
@export var player: PlayerController;

static var debug: bool = true;

var current_save_file: SaveFile;
var scroll_in_use: bool = false;

func _ready():
	on_enable.call_deferred()
	
func on_enable():
	GUI.instance.text_box.print("Be careful, most cards only have limited uses!") 

func _enter_tree():
	if not Manager.debug:
		print("Debug mode is set to " + str(debug) + ", some messages may not be shown.")
	Manager.instance = self;
	
func pause(pause_game = !get_tree().paused):
	get_tree().paused = pause_game
	if pause_game:
		SceneManager.instance.set_active_scene("pause", false);
	
func get_tile_position(position: Vector2) -> Vector2:
	return tilemap.local_to_map(position)
	
func get_tile_data_at(position: Vector2) -> TileData:
	var local_position: Vector2 = get_tile_position(position)
	return tilemap.get_cell_tile_data(0, local_position)

func get_custom_data_at(position: Vector2, custom_data_name: String) -> Variant:
	var data = get_tile_data_at(position)
	if data:
		return data.get_custom_data(custom_data_name)
	return null;

static func debug_log(s: String):
	if debug:
		print(s);
		
static func debug_warn(s: String):
	if debug:
		push_warning(s);
		
static func debug_err(s: String):
	if debug:
		printerr(s);
