class_name Card
extends Node

@export var data: CardData = null;
var cooldown_timer: Timer:
	get:
		if not cooldown_timer:
			cooldown_timer = Timer.new()
			cooldown_timer.one_shot = true;
			cooldown_timer.timeout.connect(func(): can_use = true);
			Manager.instance.orphan_timers.add_child(cooldown_timer)
		return cooldown_timer;
		
var is_front: bool = true;
var uses: int;

var can_use: bool = true;
var script_container: Node;

func _init(card_data: CardData = null):
	data = card_data;
	uses = data.uses;
		
func _exit_tree():
	cooldown_timer.queue_free()

func execute():
	if !can_use:
		return;
	
	if script_container == null:
		script_container = Node.new();
		script_container.set_script(data.exec_script)
	script_container.execute(is_front)
	
	if data.cooldown > 0:
		cooldown_timer.wait_time = data.cooldown;
		cooldown_timer.start();
		can_use = false;
		
	uses -= 1;
		
	if data.remove_from_deck_on_use:
		Manager.instance.player.deck.remove_card(data)

func flip():
	is_front = !is_front;
