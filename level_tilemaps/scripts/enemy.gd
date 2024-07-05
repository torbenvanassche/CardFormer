extends Area2D

func on_enter():
	var scene_init_data = {
		"player": Platformer.instance.player,
		"enemy": self
	}
	
	SceneManager.instance.set_active_scene("battle", SceneConfig.new(true, true, false, false, scene_init_data))
