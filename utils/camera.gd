class_name CameraController
extends Camera2D

@export var target: Node2D

@export var initial_zoom: float = 1
@export var zoom_interval: Vector2 = Vector2(2, 0.5);

@export var settings_profile: Settings;
var mouse_position:Vector2;

func _ready():
	zoom = Vector2(initial_zoom, initial_zoom)
	
func _process(delta):
	if settings_profile:
		position = position.lerp(target.position, delta * settings_profile.camera_follow_speed);
	
func _unhandled_input(_event):
	if !SceneManager.instance.ui_is_open():
		return;
		
	if Input.is_action_just_pressed("zoom_out"):
		zoom.x = clamp(zoom.x - settings_profile.camera_zoom_sensitivity, zoom_interval.x, zoom_interval.y);
	elif Input.is_action_just_pressed("zoom_in"):
		zoom.x = clamp(zoom.x + settings_profile.camera_zoom_sensitivity, zoom_interval.x, zoom_interval.y);
	zoom.y = zoom.x;
	
	if Input.is_action_just_pressed("cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
