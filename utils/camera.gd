class_name CameraController
extends Camera2D

@export var target: Node2D

@export var distance: float = 7
@export var distance_interval: Vector2i = Vector2i(5, 10);

@export var settings_profile: Settings;
var mouse_position:Vector2;
	
func _process(delta):
	if settings_profile:
		position = position.lerp(target.position, delta * settings_profile.camera_follow_speed);
	
func _unhandled_input(event):
	if !UserInterface.instance.is_ui_closed():
		return;
	
	if Input.is_action_just_pressed("enable_camera_rotate"):
		mouse_position = get_viewport().get_mouse_position()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_released("enable_camera_rotate"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_viewport().warp_mouse(mouse_position)
		
	if Input.is_action_just_pressed("zoom_out") and zoom.x < distance_interval.y:
		zoom -= Vector2(settings_profile.camera_zoom_sensitivity, settings_profile.camera_zoom_sensitivity)

	elif Input.is_action_just_pressed("zoom_in") and zoom.x > distance_interval.x:
		zoom += Vector2(settings_profile.camera_zoom_sensitivity, settings_profile.camera_zoom_sensitivity)
	
	if Input.is_action_just_pressed("cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_viewport().warp_mouse(mouse_position)
