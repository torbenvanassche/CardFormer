class_name GUI
extends Node

static var instance: GUI;

var ability_slots: Array[CardUI];
@onready var card_ui_preload = preload("res://cards/scenes/card_ui.tscn")
@export var card_parent_combat: Control;
@onready var text_box: Printer = $CanvasLayer/text_container/text_box;

func reset():
	for slot in ability_slots:
		slot.queue_free();
	ability_slots.clear();

func _ready():
	GUI.instance = self;
	Manager.instance.player.player_combat_changed.connect(set_ui_state);
	
func add_card(card: Card) -> CardUI:
	var card_instance: CardUI = card_ui_preload.instantiate()
	card_parent_combat.add_child(card_instance)
	card_instance.card = card;
	return card_instance;
	
func set_ui_state():
	if Manager.instance.player.is_in_combat:
		card_parent_combat.visible = true;
	else:
		card_parent_combat.visible = false;
