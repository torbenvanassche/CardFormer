class_name Projectile extends Node

var state: AnimationStateMachine;

func _ready() -> void:
	state = AnimationStateMachine.new($Sprite2D)
	state.current_state = "start"
