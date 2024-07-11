class_name PlayerController
extends CharacterBody2D

#Player data stuff
@export var player_sprite: AnimatedSprite2D;
@export var player_trigger: Area2D;
@export var emote_handler: EmoteHandler;
var deck: Deck = Deck.new();
@export var hand: Hand;

@onready var platforming_controller: PlatformerPlayer = $"platformer_controller"
var is_in_combat: bool = false;

#collision management
var current_triggers: Array[Node2D];

# Called when the node enters the scene tree for the first time.
func _ready():
	player_trigger.area_entered.connect(_on_enter)
	player_trigger.area_exited.connect(_on_leave)

func _on_enter(body: Node2D):
	if body != Platformer.instance.player:
		if !current_triggers.has(body):
			current_triggers.push_back(body);
		if body.has_method("on_enter"):
			body.on_enter();
	
func _on_leave(body: Node2D):
	if body != Platformer.instance.player:
		current_triggers.erase(body);
		if body.has_method("on_leave"):
			body.on_leave();

func battle(handler: BattleHandler):
	print("player act");
	handler.turn_end.emit();
