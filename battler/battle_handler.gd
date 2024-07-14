class_name BattleHandler
extends Node

var _participants: Array[Node] = []
var _current_participant_index: int = 0;
var turn_count: int = 0;

signal turn_end(n: Node)

func _init(participants: Array[Node] = []):
	randomize()

	_participants = participants
	_participants.shuffle()
	
	
	turn_end.connect(to_next)	
	to_next.call_deferred(_participants[_current_participant_index])
	
func to_next(n: Node):
	var curr_participant = _participants[_current_participant_index];
	if not Manager.instance.player.is_in_combat:
		return
		
	_current_participant_index += 1; 
	if _current_participant_index >= _participants.size():
		_current_participant_index = 0;
		turn_count += 1;
	
	if curr_participant.has_method("execute"):
		curr_participant.execute();
