extends Node

var attack_animation_name = "attack_ranged";
var projectile = preload("res://scenes/scenes/projectile.tscn")

func execute(is_front: bool = true):
	var player: PlayerController = Manager.instance.player;
	if player.is_in_combat:
		player.state_machine.animation_ended.connect(_on_attack_finished.bind(is_front), CONNECT_ONE_SHOT)
		player.state_machine.set_state(attack_animation_name);
		
func _on_attack_finished(anim_finished: String, is_front: bool):
	if anim_finished == attack_animation_name:
		var proj: Projectile = projectile.instantiate();
		Manager.instance.player.projectile_location.add_child(proj);
		var tween = Manager.instance.get_tree().root.create_tween().tween_property(proj, "global_position:x", (SceneManager.instance.active_scene as Battler).target.global_position.x, 1).set_ease(Tween.EASE_IN)
		tween.finished.connect(do_action.bind(is_front))
		tween.finished.connect(proj.queue_free)
		
func do_action(is_front: bool):
		if is_front:
			(SceneManager.instance.active_scene as Battler).target.take_damage(50)
		else:
			(SceneManager.instance.active_scene as Battler).target.take_damage(20)
		Manager.instance.battle_handler.turn_end.emit(self);
