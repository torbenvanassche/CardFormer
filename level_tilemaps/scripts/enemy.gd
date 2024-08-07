class_name Enemy
extends Area2D

@onready var health_bar: HealthBar = $HealthBar;
@onready var _indicator: TextureRect = $indicator;

signal clicked()
signal killed()

#called when the node enters the tree, this also gets called when reparenting for the combat scene
func _enter_tree():
	var parent: Node = get_parent();
	if parent is Platformer:
		_on_tree_enter_platformer.call_deferred()
	if parent is Battler:
		_on_combat_start.call_deferred();
		
func _on_tree_enter_platformer():
	pass

#handles the collision event when the player collides with this object
func on_area_enter():
	if not Manager.instance.player.is_in_combat:
		_on_area_enter_platformer();

#sub-handler for the collision for the platformer
func _on_area_enter_platformer():
	SceneManager.instance.set_active_scene("battle", SceneConfig.new(["platformer"], true, true, { "player": Manager.instance.player, "enemy": self }))

func _on_combat_start():
	health_bar.set_data()
	health_bar.is_depleted.connect(func(): killed.emit())

func execute():
	Manager.instance.battle_handler.turn_end.emit(self);
	
func _input_event(_viewport, event, _shape_idx):
	if get_parent() is Battler && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit();
		set_active();
		
func set_active():
	_indicator.visible = true;
	
func set_inactive():
	_indicator.visible = false;
		
func take_damage(amount: int):
	health_bar.decrease_health(amount);
