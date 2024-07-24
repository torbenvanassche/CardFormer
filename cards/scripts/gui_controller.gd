class_name GUI
extends Node

static var instance: GUI;

var ability_slots: Array[CardUI];
@onready var card_ui_preload = preload("res://cards/scenes/card_ui.tscn")
@onready var text_box: Printer = $CanvasLayer/text_container/text_box;
@export var deck_value: CustomAtlasTexture;

@export var card_parent_combat: Control;
@export var card_parent_platformer: Control;

func reset():
	for slot in ability_slots:
		slot.queue_free();
	ability_slots.clear();

func _ready():
	GUI.instance = self;
	Manager.instance.player.player_combat_changed.connect(_set_ui_state);
	Manager.instance.player.deck.deck_changed.connect(_card_added_to_deck)

func _card_added_to_deck():
	deck_value.index = Manager.instance.player.deck.cards.size();

func add_card(card: Card) -> CardUI:
	var card_instance: CardUI = card_ui_preload.instantiate()
	card_parent_combat.add_child(card_instance)
	card_instance.card = card;
	return card_instance;
	
func _set_ui_state():
	if Manager.instance.player.is_in_combat:
		card_parent_combat.visible = true;
		card_parent_platformer.visible = false;
	else:
		card_parent_combat.visible = false;
		card_parent_platformer.visible = true;
