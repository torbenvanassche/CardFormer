extends Node

@onready var resume_button: Button = $resume;
@onready var settings_button: Button = $settings;
@onready var quit_button: Button = $quit;

var window_controller: DraggableControl;

func _ready():	
	resume_button.pressed.connect(func(): window_controller.close_requested.emit())
	settings_button.pressed.connect(func(): print("Not implemented yet."))
	
	quit_button.pressed.connect(func(): window_controller.close_requested.emit())
	quit_button.pressed.connect(SceneManager.instance.set_active_scene.bind("main_menu", true, true))

func on_disable():
	Manager.instance.pause(false)
