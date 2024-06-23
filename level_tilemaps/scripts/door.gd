extends Triggerable

# Called when the node enters the scene tree for the first time.
func _ready():
	listen_to.on_state_changed.connect(_open_door)

func _open_door(b: bool):
	modulate = Color.BLACK if b else Color.WHITE;
