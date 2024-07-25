@tool
class_name InputDisplayer extends CustomTextureRect

@export_file("*.json") var dictionary_path: String;
var _keys: Dictionary:
	get:
		if !_keys:
			_keys = FileUtils.load_json(dictionary_path)
		return _keys;

@export var key: String:
	set(value):
		key = value;
		var entry = _keys.keyboard.get(key)
		if entry:
			rect_size = Vector2i(_keys.rect_size[0] * entry[2], _keys.rect_size[1] * entry[3]);
			indices = Vector2i(entry[0], entry[1]);
			queue_redraw()
		elif key != "":
			Debug.err(key + " is not valid.")
