extends Area2D

func on_enter():
	var scene_init_data = {
		"player": Manager.instance.player,
		"enemy": self
	}
	
	SceneManager.instance.set_active_scene("battle", true, false, scene_init_data)
