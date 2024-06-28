class_name CardUI
extends Button

@export var card: Card:
	get:
		return card;
	set(value):
		if card:
			destroy()
		card = value;
		initialize()
		
var internal_sprite: TextureRect;
var cooldown_overlay: ProgressBar;

signal left_click();
signal right_click();
	
func _process(_delta):
	if card.data.cooldown != 0:
		cooldown_overlay.value = card.cooldown_timer.time_left;

func initialize():	
	cooldown_overlay = $Sprite2D/cooldown_overlay
	internal_sprite = $Sprite2D;
	
	internal_sprite.texture = internal_sprite.texture.duplicate()
	card.cooldown_timer.timeout.connect(_reset_overlay)
		
	internal_sprite.visible = true;
	(internal_sprite.texture as AtlasTexture).region = Rect2(18 * card.data.sprite_frame, 0, 18, 18)
	
	if card.data.cooldown > 0:
		cooldown_overlay.visible = true;
		cooldown_overlay.max_value = card.data.cooldown;
	else:
		cooldown_overlay.visible = false;
	set_process(true)
	
func _reset_overlay():
	cooldown_overlay.value = 0;
	
func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			left_click.emit();
		if event.button_index == MOUSE_BUTTON_RIGHT:
			right_click.emit();
	
func destroy():	
	card.cooldown_timer.timeout.disconnect(_reset_overlay())
	internal_sprite.visible = false
	cooldown_overlay.visible = false;
