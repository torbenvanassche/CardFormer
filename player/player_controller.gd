extends CharacterBody2D

@export var player_sprite: AnimatedSprite2D;

@export var speed = 150.0
@export var jump_velocity = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");

func _physics_process(delta):	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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

	handle_trigger();
	handle_interactable()
	move_and_slide()
	
func handle_trigger():
	# Handle interactions
	var tile_data: Script = Manager.instance.get_custom_data_at(position, "trigger")
	if tile_data != null:
		Manager.instance.on_tilemap_interaction.emit(Manager.instance.get_tile_position(position), tile_data)

func handle_interactable():
	# Handle interactions
	var tile_data: Script = Manager.instance.get_custom_data_at(position, "interaction")
	if tile_data != null && Input.is_action_just_pressed("interact"):
		Manager.instance.on_tilemap_interaction.emit(Manager.instance.get_tile_position(position), tile_data)
