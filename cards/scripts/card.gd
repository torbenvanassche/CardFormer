class_name Card
extends Node

@export var data: CardData = null;
var cooldown_timer: Timer;
var is_front: bool = true;

var can_use: bool = true;

func _init(card_data: CardData = null):
	data = card_data;
	
	if !cooldown_timer:
		cooldown_timer = Timer.new();
		add_child(cooldown_timer)
		cooldown_timer.one_shot = true;
		cooldown_timer.timeout.connect(func(): can_use = true);

func execute():
	if !can_use:
		return;
		
	var function_name = "execute_front" if is_front else "execute_back";
	if data.has_method(function_name):
		data.call(function_name)
	
	if data.cooldown > 0:
		cooldown_timer.wait_time = data.cooldown;
		cooldown_timer.start();
		can_use = false;
	
	if data.single_use:
		if data.respawn_after_use and has_meta("card"):
			var card_meta: Node = get_meta("card");
			if card_meta.has_method("on_enable"):
				card_meta.on_enable();

func flip():
	is_front = !is_front;

func _exit_tree():
	cooldown_timer.queue_free()
	pass
