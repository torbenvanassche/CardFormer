extends Area2D

@onready var card_sprite: Sprite2D = $card/Sprite2D;
@export var card_data: CardData;

func _ready():
	on_enable.call_deferred()

func on_enable():
	if card_data.sprite_frame != -1:
		card_sprite.frame = card_data.sprite_frame;

func on_enter():
	Manager.instance.player.deck.add_card(card_data)
	queue_free()
