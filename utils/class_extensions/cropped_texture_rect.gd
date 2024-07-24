@tool
class_name CustomAtlasTexture extends Control

@export var texture: Texture2D;
@export var rect_size: Vector2i = Vector2i.ZERO;
@export var index: int = 0:
	set(value):
		index = value
		queue_redraw()

func _draw():
	var column: int = index % (texture.get_width() / rect_size.x);
	var row: int = index / (texture.get_width() / rect_size.x);
	draw_texture_rect_region(texture, Rect2(0, 0, size.x, size.y), Rect2(column * rect_size.x, row * rect_size.y, rect_size.x, rect_size.y))
