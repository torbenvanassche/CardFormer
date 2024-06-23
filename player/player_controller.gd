class_name PlayerController
extends CharacterBody2D

@export var player_sprite: AnimatedSprite2D;
@export var player_trigger: Area2D;
@export var emote_handler: EmoteHandler;
@export var speed: float = 150.0
@export var jump_velocity: float = -300.0
var deck: Deck = Deck.new();

var current_triggers: Array[Node2D];

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");

# Called when the node enters the scene tree for the first time.
func _ready():
	player_trigger.area_entered.connect(_on_enter)
	player_trigger.area_exited.connect(_on_leave)

func _physics_process(delta):	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		GUI.instance.try_use_ability("jump");

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if direction != 0:
		player_sprite.flip_h = direction > 0;
		player_sprite.play("walk")
	else:
		player_sprite.stop()
		
	if Input.is_action_just_pressed("interact") && current_triggers.size() != 0:
		var player: PlayerController = Manager.instance.player;
		current_triggers.sort_custom(func(a: Node2D, b: Node2D): 
			return player.position.distance_squared_to(a.position) > player.position.distance_squared_to(b.position))
		if current_triggers[0].has_method("execute"):
			current_triggers[0].execute();
	move_and_slide()
	
func jump():
	velocity.y = jump_velocity

func _on_enter(body: Node2D):
	if body != Manager.instance.player:
		if !current_triggers.has(body):
			current_triggers.push_back(body);
		if body.has_method("on_enter"):
			body.on_enter();
	
func _on_leave(body: Node2D):
	if body != Manager.instance.player:
		current_triggers.erase(body);
		if body.has_method("on_leave"):
			body.on_leave();
