class_name Enemy
extends Area2D

func on_enter():
	if get_parent() is Platformer:
		_on_enter_platformer();

func _on_enter_platformer():
	SceneManager.instance.set_active_scene("battle", SceneConfig.new(true, true, false, false, { "player": Manager.instance.player, "enemy": self }))

func execute():
	print("enemy attack");
	Manager.instance.battle_handler.turn_end.emit(self);
