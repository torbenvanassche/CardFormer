class_name StateMachine extends Node

var states: Array = [];
var _current_state: String;

func set_state(state_name: String):
	if _current_state != state_name:
		if states.has(state_name):
			state_exited.emit(_current_state);
			state_entered.emit(state_name);
			_current_state = state_name;
		else:
			on_state_not_found(state_name)

signal state_entered(state: String);
signal state_exited(state: String);

func on_state_not_found(state_name: String):
	Debug.warn("State %s is not found in the available states!" % state_name)

func _init(_states: Array = []):
	states = _states;
