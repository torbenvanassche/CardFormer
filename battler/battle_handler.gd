class_name BattleHandler
extends Node

var _participants: Array[Node] = []
var current_participant: int = 0;

signal turn_end()

func _init(participants: Array[Node] = []):
	randomize()

	_participants = participants
	_participants.shuffle()
	turn_end.connect(to_next)

	_participants[current_participant].battle(self);
	
func to_next():
	current_participant += 1;
	
	if current_participant < _participants.size():
		_participants[current_participant].battle(self);
	else:
		print("Combat loop end.")
