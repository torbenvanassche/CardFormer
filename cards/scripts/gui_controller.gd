class_name GUI
extends Node

static var instance: GUI;

var ability_slots: Array[CardUI];
@onready var card_ui_preload = preload("res://cards/scenes/card_ui.tscn")
@onready var ability_parent: Control = $CanvasLayer/MarginContainer/HBoxContainer;
@onready var text_box: Printer = $CanvasLayer/text_container/text_box;

func _ready():
	GUI.instance = self;
	ability_slots.append_array(ability_parent.get_children())

func add_to_ui(card: Card) -> CardUI:
	var card_instance: CardUI = card_ui_preload.instantiate()
	ability_parent.add_child(card_instance)
	card_instance.card = card;
	return card_instance;
