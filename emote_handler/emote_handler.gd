class_name EmoteHandler
extends Sprite2D

@export_file("*.json") var dictionary_path: String;
@onready var _emotes: Array = FileUtils.load_json(dictionary_path);
var timer: Timer = Timer.new();

@export var emote_display_time: float = 1;

func _ready():
	timer.timeout.connect(set_emote)
	timer.wait_time = emote_display_time;
	timer.one_shot = true;
	add_child(timer);
	
	scale = Vector2();
	set_emote()
	
func get_emote_by_id(id: String):
	var results = _emotes.filter(func(emote): return emote.id == id)
	if results.size() != 0:
		return results[0];
	else:
		Debug.err(id + " was not found in the emote array.")
		return null;

func set_emote(f: int = -1, remove_on_timer: bool = true):
	if f == -1:
		create_tween().tween_property(self, "scale", Vector2(), 0.1).set_ease(Tween.EASE_IN)
		return;
	self.frame = f;
	create_tween().tween_property(self, "scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_IN)
	
	if remove_on_timer:
		timer.start();
