class_name CardData
extends Resource

@export var sprite_frame: int = -1;
@export var exec_script: Script;
@export var cooldown: float = 1;
@export var single_use: bool = false;
@export var respawn_after_use = false;
@export_enum("jump", "attack", "interact") var type: String;
