class_name PlatformerPlayer
extends Node

@onready var character_body: PlayerController = $".."
@export var jump_velocity: float = -300.0
var jump_grace_period: float = 0.1;
var current_jump_timer: float = 0;
var jump_pressed_not_on_ground: bool = false;
@export var speed: float = 150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");

func _physics_process(delta):
	if not character_body.is_on_floor():
		character_body.velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump"):
		if character_body.is_on_floor():
			jump()
		else:
			jump_pressed_not_on_ground = true;
	
	if jump_pressed_not_on_ground:
		current_jump_timer += delta;
		
	if character_body.is_on_floor() and current_jump_timer < jump_grace_period and jump_pressed_not_on_ground:
		jump();

	var direction = Input.get_axis("left", "right")
	if direction:
		character_body.velocity.x = direction * speed
	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, speed)
		
	if direction != 0:
		character_body.player_sprite.flip_h = direction > 0;
		character_body.player_sprite.play("walk")
	else:
		character_body.player_sprite.stop()
		
	if Input.is_action_just_pressed("interact") && character_body.current_triggers.size() != 0:
		interact();
	character_body.move_and_slide()
	
func jump():
	character_body.velocity.y = jump_velocity
	jump_pressed_not_on_ground = false;
	current_jump_timer = 0;
	
func interact():	
	character_body.current_triggers.sort_custom(func(a: Node2D, b: Node2D): 
		return character_body.position.distance_squared_to(a.position) > character_body.position.distance_squared_to(b.position))
	if character_body.current_triggers.size() != 0 and character_body.current_triggers[0].has_method("execute"):
		character_body.current_triggers[0].execute();
		
func attack():
	print("attack")
