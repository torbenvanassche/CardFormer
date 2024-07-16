class_name HealthBar
extends Node

@export var _max_health: int = 100;
@export var _current_health: int = 100;

signal death()

func _init(max_health: int = 100, current_health = max_health):
	_max_health = max_health;
	_current_health = current_health;

func decrease_health(amount: int):
	_current_health -= amount;
	if _current_health < 0:
		death.emit()
		
func is_alive():
	return _current_health > 0;
