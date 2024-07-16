class_name PlayerController
extends CharacterBody2D

#Player data stuff
var deck: Deck = Deck.new();
var hand: Hand = Hand.new();

@onready var platforming_controller: PlatformerPlayer = $"platformer_controller"
@onready var player_sprite: AnimatedSprite2D = $player_sprite
@onready var emote_handler: EmoteHandler = $emote_handler;
@onready var player_trigger: Area2D = $player_trigger;

var current_triggers: Array[Node2D];
var is_in_combat: bool = false;

func _init():
	Manager.instance.player = self;

# Called when the node enters the scene tree for the first time.
func _ready():
	player_trigger.area_entered.connect(_on_enter)
	player_trigger.area_exited.connect(_on_leave)

func _on_enter(body: Node2D):
	if !current_triggers.has(body):
		current_triggers.push_back(body);
		if body.has_method("on_area_enter"):
			body.on_area_enter();
	
func _on_leave(body: Node2D):
	current_triggers.erase(body);
	if body.has_method("on_area_leave"):
		body.on_area_leave();
