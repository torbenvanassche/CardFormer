class_name CardData
extends Resource

@export var sprite_frame: int = -1;
@export var exec_script: Script;
@export var cooldown: float = 1;
@export var uses: int = 1;
@export var shuffle_after_use: bool = false;
@export var remove_from_deck_on_use: bool = false;
@export_enum("jump", "attack", "interact") var type: String;
