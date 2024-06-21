
class_name Manager
extends Node

static var instance: Manager;

@export var scenes: Array[Node]
@export var tilemap: TileMap;
var camera: Camera2D;

static var debug: bool = false;

var current_save_file: SaveFile;
var scroll_in_use: bool = false;

signal on_tilemap_trigger(position: Vector2, script: Script);
signal on_tilemap_interaction(position: Vector2, script: Script);

func _enter_tree():
	print("Debug mode is set to " + str(debug))
	Manager.instance = self;
	
func _ready():
	on_tilemap_interaction.connect(func(pos:Vector2, script: Script): script.execute({"position": pos}))
	
func pause(pause_game = true):
	get_tree().paused = pause_game
	
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
