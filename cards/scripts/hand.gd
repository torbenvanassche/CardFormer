class_name Hand
extends Node

var card_container: Array[CardUI];
@export var hand_size: int = 3;

func add_card(card: Card):
	if is_full():
		return false
	
	var slot: CardUI = GUI.instance.add_card(card);
	slot.left_click.connect(try_use_ability.bind(slot))
	
	slot.right_click.connect(card.flip)
	slot.right_click.connect(slot.flip)
	
	card_container.append(slot);
	add_child(card)
	
	if slot.has_method("on_enter"):
		slot.on_enter();
	return true;
	
func is_full() -> bool:
	return card_container.size() >= hand_size;

func remove_ability(slot_index: int) -> void:
	card_container[slot_index].remove_script();
	
func remove_all_abilities() -> void:
	for card in card_container:
		card.queue_free();
	card_container.clear();
		
func try_use_ability(slot: CardUI) -> void:
	if slot.card.has_method("execute") && slot.card.can_use:
		slot.card.execute();
		if slot.card.uses <= 0:
			card_container.erase(slot)
			slot.queue_free()
		
		
func has_ability(ability: String) -> bool:
	return card_container.any(func(x: CardUI): return x.card.data.type == ability);
