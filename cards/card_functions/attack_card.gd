extends Node

func execute(is_front: bool = true):
	if Manager.instance.player.is_in_combat:
		if is_front:
			print("front attack")
		else:
			print("back attack")
		Manager.instance.battle_handler.turn_end.emit(self);
	else:
		if is_front:
			print("front platformer")
		else:
			print("back platformer")
