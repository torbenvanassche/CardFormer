extends Triggerable

func _ready():
	listen_to.on_state_changed.connect(_change_visibility)
	visible = listen_to.is_on;

func _change_visibility(b: bool):
	visible = b;
