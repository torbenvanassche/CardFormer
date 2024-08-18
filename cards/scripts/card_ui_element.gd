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
var card_background: TextureRect;

@onready var card_front: Texture = preload("res://cards/import/card_front.png");
@onready var card_back: Texture = preload("res://cards/import/card_back.png");

signal left_click();
signal right_click();
	
func _process(_delta):
	if card != null && card.data.cooldown != 0 && card.cooldown_timer != null:
		cooldown_overlay.value = card.cooldown_timer.time_left;

func initialize():	
	cooldown_overlay = $ability_card/cooldown_overlay;
	card_background = $ability_card;
	internal_sprite = $ability_card/Sprite2D;
	
	card_background.texture = card_front if card.is_front else card_back;
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
		release_focus()
		if event.button_index == MOUSE_BUTTON_LEFT:
			left_click.emit();
		if event.button_index == MOUSE_BUTTON_RIGHT:
			right_click.emit();
			
func flip():
	card_background.texture = card_front if card.is_front else card_back;
	
func destroy():
	card.cooldown_timer.timeout.disconnect(_reset_overlay)
	internal_sprite.visible = false
	cooldown_overlay.visible = false;
