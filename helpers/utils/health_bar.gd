class_name HealthBar
extends ProgressBar

@export var max_health: int = 100;
@export var current_health: int = 100;
var time_to_depletion: float = 0.5;

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
	create_tween().tween_property(self, "value", current_health, time_to_depletion).finished.connect(check_alive)
	
func check_alive():
	if not is_alive():
		is_depleted.emit();
		
func is_alive():
	return current_health > 0;
