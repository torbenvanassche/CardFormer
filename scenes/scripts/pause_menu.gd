extends Node

@onready var resume_button: Button = $resume;
@onready var settings_button: Button = $settings;
@onready var quit_button: Button = $quit;

func _ready():
	#resume_button.pressed.connect(Manager.instance.pause)
	#settings_button.pressed.connect(func(): print("Not implemented yet."))
	#quit_button.pressed.connect(SceneManager.instance.set_active_scene.bind("main_menu", true))
	pass
