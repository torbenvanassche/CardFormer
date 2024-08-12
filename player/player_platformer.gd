class_name PlatformerPlayer
extends Node

@onready var character_body: PlayerController = $".."
@export var speed: float = 150.0;

@export_group("Jump")
@export var jump_height : float = 100
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.3
var jump_grace_period: float = 0.1;
var jump_coyote_time: float = 0.1

@onready var jump_velocity : float = -((2.0 * jump_height) / jump_time_to_peak)
@onready var jump_gravity : float = ((2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity : float = ((2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))
@onready var jump_coyote_default_time: float = jump_coyote_time
@onready var _initial_jump_cooldown := _jump_cooldown
var jump_pressed_not_on_ground: bool = false;
var current_jump_timer: float = 0;
var _jump_cooldown := 0.1;
var _can_jump := true;

var _gravity: float:
	get:
		return jump_gravity if character_body.velocity.y < 0.0 else fall_gravity

func _process_platformer(delta: float):
	if jump_pressed_not_on_ground:
		current_jump_timer += delta;
		
	if not _can_jump:
		_jump_cooldown -= delta;
		if _jump_cooldown <= 0:
			_can_jump = true;
			
		
	var jump_coyote := false;
	var jump_buffer := false;
	if not character_body.is_on_floor():
		jump_coyote_time -= delta;
		if Input.is_action_just_pressed("jump"):
			jump_pressed_not_on_ground = true;
			jump_coyote = jump_coyote_time > 0;
	else:
		jump_coyote_time = jump_coyote_default_time
		if Input.is_action_just_pressed("jump"):
			jump();
			
	jump_buffer = current_jump_timer < jump_grace_period and jump_pressed_not_on_ground and character_body.is_on_floor();
	if (jump_buffer || jump_coyote):
		jump()

	var direction = Input.get_axis("left", "right")
	if direction:
		character_body.velocity.x = direction * speed
	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, speed)
		
	if direction != 0:
		character_body.player_sprite.flip_h = direction > 0;
		
	if character_body.is_on_floor():
		if direction != 0:
			character_body.state_machine.current_state = "walk";
		else:
			character_body.state_machine.current_state = "idle";
	else:
		character_body.state_machine.current_state = "jump"
		
	if Input.is_action_just_pressed("interact") && character_body.current_triggers.size() != 0:
		interact();

func _physics_process(delta):
	if not character_body.is_on_floor():
		character_body.velocity.y += _gravity * delta;
		
	if not character_body.is_in_combat:
		_process_platformer(delta)
	
	character_body.move_and_slide()
	
func jump():
	if not _can_jump:
		return
	
	character_body.state_machine.current_state = "jump"
	character_body.velocity.y = jump_velocity
	_jump_cooldown = _initial_jump_cooldown;
	jump_pressed_not_on_ground = false;
	current_jump_timer = 0;
	_can_jump = false;
	
func interact():	
	character_body.current_triggers.sort_custom(func(a: Node2D, b: Node2D): 
		return character_body.position.distance_squared_to(a.position) > character_body.position.distance_squared_to(b.position))
	if character_body.current_triggers.size() != 0 and character_body.current_triggers[0].has_method("execute"):
		character_body.current_triggers[0].execute();
