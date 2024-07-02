extends Area2D

func on_enter():
	SceneManager.instance.set_active_scene("battle", true, false)
