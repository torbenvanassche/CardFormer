class_name Battler
extends Node

@export var camera: Camera2D;

@onready var player_position: Node2D = $PlayerPosition;
@onready var enemy_position: Node2D = $EnemyPosition;
var target: Enemy;

func on_enable(options: Dictionary):
	#set to the correct camera
	camera.make_current();
	if options != {}:
		apply_options.call_deferred(options)
	
func apply_options(options: Dictionary):
	var player: PlayerController = options.player;
	player.velocity = Vector2()
	player.is_in_combat = true;
	player.player_sprite.flip_h = true;
	
	var enemies: Array[Node] = [];
	if options.enemy is Array:
		enemies = options.enemy;
	else: 
		enemies = [options.enemy]
	
	var participants = enemies.duplicate();
	participants.append(player)
	Manager.instance.battle_handler = BattleHandler.new(participants);
	
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
		
