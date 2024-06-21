extends Area2D

var is_on: bool = false;

@onready var animated_sprite: AnimatedSprite2D = $lever;
@onready var last_frame: int = animated_sprite.sprite_frames.get_frame_count("turn_on") - 1;

func _ready():
	animated_sprite.animation_finished.connect(_set_lever_state)
	
func _set_lever_state():
	is_on = animated_sprite.frame == last_frame;
	
func execute():
	if animated_sprite.is_playing():
		return;
	
	if !is_on:
		animated_sprite.play("turn_on")
	else: 
		animated_sprite.play_backwards("turn_on")
