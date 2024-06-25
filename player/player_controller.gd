class_name PlayerController
extends CharacterBody2D

#Player data stuff
@export var player_sprite: AnimatedSprite2D;
@export var player_trigger: Area2D;
@export var emote_handler: EmoteHandler;
@export var speed: float = 150.0
var deck: Deck = Deck.new();

#collision management
var current_triggers: Array[Node2D];

#jump parameters
@export var jump_velocity: float = -300.0
var jump_grace_period: float = 0.1;
var current_jump_timer: float = 0;
var jump_pressed_not_on_ground: bool = false;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");

# Called when the node enters the scene tree for the first time.
func _ready():
	player_trigger.area_entered.connect(_on_enter)
	player_trigger.area_exited.connect(_on_leave)

func _physics_process(delta):	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			GUI.instance.try_use_ability("jump");
		else:
			jump_pressed_not_on_ground = true;
	
	if jump_pressed_not_on_ground:
		current_jump_timer += delta;
		
	if is_on_floor() and current_jump_timer < jump_grace_period and jump_pressed_not_on_ground:
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
		if GUI.instance.try_use_ability("interact") == null:
			var emote = Manager.instance.player.emote_handler.get_emote_by_id("CROSS")
			Manager.instance.player.emote_handler.set_emote(emote.frame)
	move_and_slide()
	
func jump():
	velocity.y = jump_velocity
	jump_pressed_not_on_ground = false;
	current_jump_timer = 0;
	
func interact():	
	current_triggers.sort_custom(func(a: Node2D, b: Node2D): 
		return position.distance_squared_to(a.position) > position.distance_squared_to(b.position))
	if current_triggers.size() != 0 and current_triggers[0].has_method("execute"):
		current_triggers[0].execute();
		
func attack():
	pass

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
