class_name Hand
extends Node

var cards: Array[Card];

func add_card(card: Card):
	var slot: CardUI = GUI.instance.add_to_ui(card);
	slot.left_click.connect(try_use_ability.bind(card.data.type))
	
	slot.right_click.connect(card.flip)
	slot.right_click.connect(slot.flip)
	
	cards.append(card);
	add_child(card)
	
	if slot.has_method("on_enter"):
		slot.on_enter();

func remove_ability(slot_index: int) -> void:
	cards[slot_index].remove_script();
	
func remove_all_abilities() -> void:
	for card in cards:
		card.queue_free();
	cards.clear();
		
func try_use_ability(ability: String) -> Card:
	var filtered: Array[Card] = cards.filter(func(x: Card): return x.data.type == ability);
	if filtered.size() != 0 && filtered[0].has_method("execute") && filtered[0].can_use:
		filtered[0].execute();
		return filtered[0];
	else:
		return null;
		
func has_ability(ability: String):
	return cards.any(func(x: Card): return x.data.type == ability);
