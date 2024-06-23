extends Area2D

var is_on: bool = false;

@onready var animated_sprite: AnimatedSprite2D = $lever;
@onready var last_frame: int = animated_sprite.sprite_frames.get_frame_count("turn_on") - 1;
@onready var ui_sprite: Sprite2D = $Sprite2D;

func _ready():
	animated_sprite.animation_finished.connect(_set_lever_state)
	ui_sprite.visible = false;
	
func _set_lever_state():
	is_on = animated_sprite.frame == last_frame;
	
func execute():
	if animated_sprite.is_playing():
		return;
	
	if !is_on:
		animated_sprite.play("turn_on")
	else: 
		animated_sprite.play_backwards("turn_on")

func on_enter():
	ui_sprite.visible = true;

func on_leave():
	ui_sprite.visible = false;
