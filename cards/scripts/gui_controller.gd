class_name GUI
extends Node

static var instance: GUI;

var ability_slots: Array[Control];
@onready var ability_parent: Control = $CanvasLayer/NinePatchRect/MarginContainer/HBoxContainer;

func _ready():
	GUI.instance = self;
	ability_slots.append_array(ability_parent.get_children())

func get_open_ability_slot() -> Control:
	var options = ability_slots.filter(func(slot: Control): return slot.get_script() == null)
	if options.size() != 0:
		return options[0];
	else:
		Manager.debug_log("No space in ability slots");
		return null;

func remove_ability(slot_index: int) -> void:
	ability_slots[slot_index].remove_script();
	
func remove_all_abilities() -> void:
	for ability in ability_slots:
		ability.remove_script();
		
func try_use_ability(ability: String) -> Control:
	var filtered = ability_slots.filter(func(x: Button): return x.get_script() != null and x.card_data.type == ability);
	if filtered.size() != 0:
		trigger_click(filtered[0])
		return filtered[0];
	else:
		return null;

func trigger_click(button: Button):
	var press = InputEventMouseButton.new()
	press.set_button_index(MOUSE_BUTTON_LEFT)
	press.set_position(button.global_position)
	press.set_pressed(true)
	Input.parse_input_event(press)
	var release = InputEventMouseButton.new()
	release.set_button_index(MOUSE_BUTTON_LEFT)
	release.set_position(button.global_position)
	release.set_pressed(false)
	Input.parse_input_event(release)
