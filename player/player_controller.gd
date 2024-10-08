class_name PlayerController
extends CharacterBody2D

#Player data stuff
@onready var projectile_location: Node2D = $player_sprite/projectile_location;
@onready var platforming_controller: PlatformerPlayer = $"platformer_controller"
@onready var player_sprite: AnimatedSprite2D = $player_sprite;
@onready var health_bar: HealthBar = $HealthBar;
@onready var emote_handler: EmoteHandler = $emote_handler;
@onready var player_trigger: Area2D = $player_trigger;
@onready var deck: Deck = $Deck;
@onready var hand: Hand = $Hand;
	
var state_machine: AnimationStateMachine;
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
	
func _ready():
	player_trigger.area_entered.connect(_on_enter)
	player_trigger.area_exited.connect(_on_leave)
	is_in_combat = false;
	
	state_machine = AnimationStateMachine.new(player_sprite)

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
	player_sprite.flip_h = true;
	player_sprite.animation = "idle"
