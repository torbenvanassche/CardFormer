class_name PlatformerPlayer
extends Node

@onready var character_body: PlayerController = $".."
var jump_grace_period: float = 0.1;
var current_jump_timer: float = 0;
var jump_pressed_not_on_ground: bool = false;
@export var speed: float = 150.0;

#jump
@export var jump_height : float = 100
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var _jumped: bool = false;

func _get_gravity() -> float:
	if character_body.velocity.y >= 0 and Input.is_action_pressed("jump"):
		return ((2.0 * jump_height) / (jump_time_to_peak ** 2))
	else:
		pass
		_jumped = false
		return ((2.0 * jump_height) / (jump_time_to_peak ** 2))

func _process_platformer(delta: float):
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
		character_body.state_machine.current_state = "walk";
	else:
		character_body.state_machine.current_state = "idle";
		
	if Input.is_action_just_pressed("interact") && character_body.current_triggers.size() != 0:
		interact();

func _physics_process(delta):
	if not character_body.is_on_floor():
		character_body.velocity.y += _get_gravity() * delta;
		
	if not character_body.is_in_combat:
		_process_platformer(delta)
	
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
