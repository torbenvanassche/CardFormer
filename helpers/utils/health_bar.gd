class_name HealthBar
extends ProgressBar

@export var max_health: int = 100;
@export var current_health: int = 100;

signal is_depleted()

func set_data(curr_health: int = max_health):
	var value_padding = get_theme_stylebox("background").get("border_width_left") * 2
	current_health = curr_health
	
	visible = true;
	mouse_filter = Control.MOUSE_FILTER_IGNORE;
	max_value = max_health + value_padding;
	value = current_health;

func decrease_health(amount: int):
	current_health -= amount;
	value = current_health;
	
	if current_health <= 0:
		is_depleted.emit()
		
func is_alive():
	return current_health > 0;
