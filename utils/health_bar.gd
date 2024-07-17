class_name HealthBar
extends Node

@export var max_health: int = 100;
@export var current_health: int = 100;
var health_ui: ProgressBar;

signal is_depleted()

func set_data(_progress_bar: ProgressBar, curr_health: int = max_health):
	var value_padding = _progress_bar.get_theme_stylebox("background").get("border_width_left") * 2
	health_ui = _progress_bar;
	current_health = curr_health
	
	health_ui.visible = true;
	health_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	health_ui.max_value = max_health + value_padding;
	health_ui.value = current_health;

func decrease_health(amount: int):
	current_health -= amount;
	health_ui.value = current_health;
	
	if current_health <= 0:
		is_depleted.emit()
		
func is_alive():
	return current_health > 0;
