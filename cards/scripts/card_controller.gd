extends Area2D

@onready var card_sprite: Sprite2D = $card/Sprite2D;
@export var card_data: CardData;

@export var show_indicator: bool = false;

func _ready():
	on_enable.call_deferred()

func on_enable():
	monitorable = true;
	if card_data.sprite_frame != -1:
		card_sprite.frame = card_data.sprite_frame;

func on_enter():
	Manager.instance.player.deck.add_card(card_data)
	if card_data.respawn_after_use:
		card_data.set_meta("card", self)
		set_deferred("monitorable", false)
		visible = false;
	else:
		queue_free()
