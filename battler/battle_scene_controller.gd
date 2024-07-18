class_name Battler
extends Node

@export var camera: Camera2D;

@onready var player_position: Node2D = $PlayerPosition;
@onready var enemy_position: Node2D = $EnemyPosition;
var target: Enemy: 
	set(value):
		if target:
			target.set_inactive()
		target = value;
		target.set_active()

func on_enable(options: Dictionary):
	#set to the correct camera
	camera.make_current();
	if options != {}:
		apply_options.call_deferred(options)
	
func apply_options(options: Dictionary):
	var player: PlayerController = options.player;
	player.set_combat_state(true)
	
	var enemies: Array[Node] = []
	if options.enemy is Array:
		enemies = options.enemy;
	else: 
		enemies = [options.enemy]
	
	var participants = enemies.duplicate();
	participants.append(player)
	Manager.instance.battle_handler = BattleHandler.new(participants);
	Manager.instance.battle_handler.combat_end.connect(_on_combat_end)
	
	#store old position to place player back later
	player.set_meta("position", player.global_position);
	player.get_parent().remove_child(player);
	add_child(player);
	player.global_position = player_position.global_position;
	
	for enemy in enemies:
		var typed_enemy: Enemy = enemy;
		typed_enemy.set_meta("position", typed_enemy.global_position);
		typed_enemy.get_parent().remove_child(typed_enemy);
		add_child(typed_enemy);
		typed_enemy.global_position = enemy_position.global_position;
		typed_enemy.clicked.connect(func(): target = typed_enemy);
		typed_enemy.killed.connect(Manager.instance.battle_handler.remove_participants.bind(typed_enemy))
	target = enemies[0]
	
#sub-handler for the collision for the platformer
func _on_combat_end():
	SceneManager.instance.set_active_scene("platformer", SceneConfig.new(true, true, false, false, { "player": Manager.instance.player }))
