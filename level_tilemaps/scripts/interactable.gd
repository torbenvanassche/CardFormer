class_name Interactable
extends Area2D

@export var ui_sprite: Sprite2D;

var is_on: bool = false;
signal on_state_changed(state: bool);

func _ready():
	if ui_sprite:
		ui_sprite.scale = Vector2()

func on_enter():
	if ui_sprite:
		create_tween().tween_property(ui_sprite, "scale", Vector2(1, 1), 0.2);

func on_leave():
	if ui_sprite:
		create_tween().tween_property(ui_sprite, "scale", Vector2(), 0.2);
