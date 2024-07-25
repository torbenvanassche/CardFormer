@tool
class_name CustomTextureRect extends Control

@export var texture: Texture2D;
@export var rect_size: Vector2i = Vector2i.ZERO;
@export var indices: Vector2i = Vector2i.ZERO:
	set(value):
		indices = value
		queue_redraw()

func _draw():
	draw_texture_rect_region(texture, Rect2(0, 0, size.x, size.y), Rect2(indices.x * rect_size.x, indices.y * rect_size.y, rect_size.x, rect_size.y))
