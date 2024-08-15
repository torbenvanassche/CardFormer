class_name PlayerController
extends CharacterBody2D

#Player data stuff
var deck: Deck = Deck.new();
var hand: Hand = Hand.new();

@onready var platforming_controller: PlatformerPlayer = $"platformer_controller"
@onready var player_sprite: AnimatedSprite2D = $player_sprite;
@onready var health_bar: HealthBar = $HealthBar;
@onready var emote_handler: EmoteHandler = $emote_handler;
@onready var player_trigger: Area2D = $player_trigger;
var state_machine: StateMachine;

signal player_combat_changed();

var current_triggers: Array[Node2D];
var sprite_flip_state: bool = true;
var is_in_combat: bool = false:
	set(value):
		is_in_combat = value;
		player_combat_changed.emit();
		health_bar.visible = is_in_combat;

func _init():
	Manager.instance.player = self;
	
func _set_animation(s: String):
	if player_sprite.sprite_frames.has_animation(s):
		player_sprite.play(s)
	
func _ready():
	player_trigger.area_entered.connect(_on_enter)
	player_trigger.area_exited.connect(_on_leave)
	
	state_machine = StateMachine.new(player_sprite.sprite_frames.get_animation_names())
	state_machine.state_entered.connect(_set_animation)

func _on_enter(body: Node2D):
	if !current_triggers.has(body):
		current_triggers.push_back(body);
		current_triggers.sort_custom(func(a: Node2D, b: Node2D): 
			return global_position.distance_squared_to(a.global_position) > global_position.distance_squared_to(b.global_position));

		if body.has_method("on_area_enter"):
			body.on_area_enter();
	
func _on_leave(body: Node2D):
	current_triggers.erase(body);
	if body.has_method("on_area_leave"):
		body.on_area_leave();

func set_combat_state(in_combat: bool):
	if in_combat:
		velocity = Vector2()
	is_in_combat = in_combat;
	player_sprite.flip_h = false;
	player_sprite.animation = "attack_idle"
