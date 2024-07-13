class_name Platformer;
extends Node

static var instance: Platformer;
@export var tilemap: TileMap;
@export var camera: Camera2D;

func _enter_tree():
	Platformer.instance = self;
	SceneManager.instance.set_active_scene("gui", SceneConfig.new())
	
func on_enter():
	camera.make_current()

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
