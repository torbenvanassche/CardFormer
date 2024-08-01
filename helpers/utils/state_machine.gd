class_name StateMachine extends Node

var states: Array = [];
var current_state: String:
	set(value):
		if current_state != value:
			if states.has(value):
				state_exited.emit(current_state);
				state_entered.emit(value);
				current_state = value;
			else:
				print("State %s is not found in the available states." % value)

signal state_entered(state: String);
signal state_exited(state: String);

func _init(_states: Array = []):
	states = _states;
