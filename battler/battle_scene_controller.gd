extends Node

@export var camera: Camera2D;

@onready var player_position: Node2D = $PlayerPosition;
@onready var enemy_position: Node2D = $EnemyPosition;
var battle_handler: BattleHandler;

func on_enable(options: Dictionary):
	#set to the correct camera
	camera.make_current();
	if options != {}:
		apply_options.call_deferred(options)
		battle_handler.new();
	
func apply_options(options: Dictionary):
	var player: CharacterBody2D = options.player;
	var enemy: Enemy = options.enemy;
	
	#store old position to place player back later
	player.set_meta("position", player.global_position);
	enemy.set_meta("position", enemy.global_position);
	
	#reparent
	player.get_parent().remove_child(player);
	enemy.get_parent().remove_child(enemy);
	
	add_child(player);
	add_child(enemy);
	
	#reposition
	player.global_position = player_position.global_position;
	enemy.global_position = enemy_position.global_position;
