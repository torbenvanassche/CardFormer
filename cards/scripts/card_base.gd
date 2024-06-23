class_name CardBase
extends Button

var internal_sprite: TextureRect;
var cooldown_overlay: ProgressBar;
var cooldown_timer: Timer;

@export var card_data: CardData;
	
func _process(_delta):
	cooldown_overlay.value = cooldown_timer.time_left;

func on_enter():
	_on_enter_local()
	
	if cooldown_timer == null:
		cooldown_timer = Timer.new();
		add_child(cooldown_timer)
		cooldown_timer.one_shot = true;
		
	cooldown_overlay = $Sprite2D/cooldown_overlay
	
	internal_sprite = $Sprite2D;
	internal_sprite.texture = internal_sprite.texture.duplicate()
	if !pressed.is_connected(_execute):
		pressed.connect(_execute)
		
	if !cooldown_timer.timeout.is_connected(_reset_ability):
		cooldown_timer.timeout.connect(_reset_ability)
		
	internal_sprite.visible = true;
	(internal_sprite.texture as AtlasTexture).region = Rect2(18 * card_data.sprite_frame, 0, 18, 18)
	if card_data.cooldown > 0:
		cooldown_timer.wait_time = card_data.cooldown;
		cooldown_overlay.max_value = card_data.cooldown;
	else:
		cooldown_overlay.visible = false;
	set_process(true)
	
func _reset_ability():
	cooldown_overlay.value = 0;
	
func _on_enter_local():
	pass

func _execute():
	if !cooldown_timer.is_stopped():
		return;
	
	if card_data.cooldown > 0:
		cooldown_timer.start();
	execute();

func execute():
	Manager.debug_err("Execute is called, but is not implemented!")
