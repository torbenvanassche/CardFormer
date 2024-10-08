class_name DraggableControl
extends CanvasLayer

@onready var vp := get_viewport()
@onready var window_reference: Control = $"Window";
@onready var top_bar: ColorRect = $Window/VBoxContainer/topbar;
@onready var close_button: Button = $Window/VBoxContainer/topbar/HBoxContainer/Button;
@onready var title: Label = $Window/VBoxContainer/topbar/HBoxContainer/MarginContainer/Title;
@onready var content_panel: ColorRect = $Window/VBoxContainer/content;
@onready var background_color: Color = $Window/VBoxContainer/content.color;

@export_enum("fullscreen", "display", "no_header", "none") var display_mode: String = "display"
@export_enum("mouse", "center", "override") var position_options: String = "center";
var initial_position: Vector2;

@export var store_position: bool = false;
@export var override_position: Vector2;
@export var override_size: Vector2;
@export var sub_elements: Array[Node];
@export var return_on_close: bool = true;

signal close_requested();
signal change_title(name: String);

var dragging := false
var stored_position:Vector2;

func _ready():
	close_button.pressed.connect(close_window);
	close_requested.connect(close_window)
	top_bar.gui_input.connect(handle_input)
	change_title.connect(_change_title)
	
	for n in sub_elements:
		if n:
			if "window_controller" in n:
				n.window_controller = self;
			if n.has_method("on_enable"):
				n.on_enable();
			if n.has_method("on_disable"):
				close_requested.connect(n.on_disable)
	
	if override_size != Vector2.ZERO:
		self.set_deferred("size", override_size)
		top_bar.custom_minimum_size = Vector2(override_size.x, 50)
		content_panel.custom_minimum_size = Vector2(override_size.x, override_size.y - top_bar.size.y)
	
func on_enable(_options: Dictionary = {}):
	visible = true;
		
	match display_mode:
		"fullscreen":
			top_bar.visible = false;
			content_panel.color = background_color;
			window_reference.size = window_reference.get_viewport_rect().size;
		"display":
			top_bar.visible = true;
			content_panel.color = background_color;
			pass
		"no_header":
			top_bar.visible = false;
			content_panel.color = background_color;
			pass
		"none":
			top_bar.visible = false;
			content_panel.color = Color.TRANSPARENT;
			pass
	
	match position_options:
		"mouse":
			initial_position = get_tree().root.get_viewport().get_mouse_position();
		"center":
			initial_position = window_reference.get_viewport_rect().size / 2
		"override":
			initial_position = override_position;
	window_reference.position = initial_position - window_reference.size / 2;

	if store_position:
		window_reference.position = stored_position;

func _change_title(s: String):
	title.text = s;

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		dragging = event.pressed
	elif dragging and event is InputEventMouseMotion:
		window_reference.position += event.relative
	else:
		return
	vp.set_input_as_handled()

func close_window():
	if store_position:
		stored_position = window_reference.position;
	SceneManager.instance.to_previous_scene(return_on_close)
	
func _unhandled_input(event):	
	if event.is_action_pressed("cancel") && visible:
		vp.set_input_as_handled()
		close_requested.emit()
