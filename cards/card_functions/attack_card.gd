extends Node

func execute(is_front: bool = true):
	if Manager.instance.player.is_in_combat:
		if is_front:
			(SceneManager.instance.active_scene as Battler).target.take_damage(50)
		else:
			(SceneManager.instance.active_scene as Battler).target.take_damage(20)
		Manager.instance.battle_handler.turn_end.emit(self);
