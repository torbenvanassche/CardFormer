class_name AnimationStateMachine extends StateMachine

signal animation_ended(animation_name: String);

var target_sprite: AnimatedSprite2D;

func _set_animation(s: String):
	if target_sprite.sprite_frames.has_animation(s):
		target_sprite.play(s)

func _init(animated_sprite: AnimatedSprite2D):
	target_sprite = animated_sprite;
	states = target_sprite.sprite_frames.get_animation_names();
	target_sprite.animation_finished.connect(func(): animation_ended.emit(target_sprite.animation))
	state_entered.connect(_set_animation)

func on_state_not_found(state_name: String):
	animation_ended.emit(state_name)
