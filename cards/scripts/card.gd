class_name Card
extends Node

@export var data: CardData = null;
var cooldown_timer: Timer;
var is_front: bool = true;

var can_use: bool = true;
var script_container: Node;

func _init(card_data: CardData = null):
	data = card_data;
	
	if !cooldown_timer:
		cooldown_timer = Timer.new()
		cooldown_timer.one_shot = true;
		cooldown_timer.timeout.connect(func(): can_use = true);
		Manager.instance.orphan_timers.add_child(cooldown_timer)
		
func _exit_tree():
	cooldown_timer.queue_free()

func execute():	
	if !can_use:
		return;
	
	if script_container == null:
		script_container = Node.new();
		script_container.set_script(data.exec_script)
	else:
		script_container.execute(is_front)
	
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
