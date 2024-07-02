class_name SceneManager
extends Node

@export var scenes: Array[SceneInfo];
static var instance: SceneManager;
var game_loaded_timestamp: Dictionary;

signal scene_entered(scene: Node)
signal scene_exited(scene: Node)

func _ready():
	SceneManager.instance = self;
	set_active_scene("main_menu", true, true)

var active_scene: Node:
	get: return active_scene;
	set(new_scene):
		if !new_scene:
			return;
		if active_scene:
			scene_exited.emit(active_scene);
			if active_scene.has_method("on_disable"):
				active_scene.on_disable();
		active_scene = new_scene;
		active_scene.visible = true;
		
		scene_entered.emit(active_scene);
		if active_scene.has_method("on_enable"):
			active_scene.on_enable();
			
func get_or_create_scene(scene_name: String):	
	var filtered: Array = scenes.filter(func(scene: SceneInfo): return scene.id == scene_name);
	if filtered.size() == 0:
		Manager.debug_err(scene_name + " was not found, unable to instantiate!")	
	elif filtered.size() == 1:
		var scene_info: SceneInfo = filtered[0];
		if is_instance_valid(scene_info.node):
			return scene_info.node;
		else:
			var node = scene_info.packed_scene.instantiate();
			add_child(node)
			scene_info.node = node
			return node;
	else:
		Manager.debug_err(scene_name + " was invalid.")
		
func node_to_info(node: Node) -> SceneInfo:
	var filtered = scenes.filter(func(x: SceneInfo): return x.node == node);
	if filtered.size() == 1:
		return filtered[0];
	Manager.debug_err("Could not find " + node.name + " in scenes.")
	return null
		
func set_active_scene(scene_name: String, hide_current_scene: bool, free_current_scene: bool = false, options: Dictionary = {}) -> Node:
	var previous_scene_info: SceneInfo = null;
	if active_scene:
		previous_scene_info = node_to_info(active_scene);
		if hide_current_scene:
			active_scene.visible = false;
		if free_current_scene: 
			previous_scene_info.node.queue_free() 
	active_scene = get_or_create_scene(scene_name)
	if active_scene:
		active_scene.set_meta("previous_scene_info", previous_scene_info)
		if active_scene.has_method("on_enable"):
			active_scene.on_enable(options)
	return active_scene;
		
func to_previous_scene(hide_current: bool = false, remove_current: bool = false):
	var scene_info: SceneInfo = active_scene.get_meta("previous_scene_info")
	active_scene.remove_meta("previous_scene_info")

	if scene_info:
		set_active_scene(scene_info.id, hide_current, remove_current);
		
func ui_is_open(exceptions: Array[String] = ["pause"]) -> bool:
	return get_children().all(func(x: Node): return node_to_info(x).is_ui && x.visible && !exceptions.has(node_to_info(x).id));

func _unhandled_input(event):
	if event.is_action_pressed("cancel") && !ui_is_open():
		Manager.instance.pause();
