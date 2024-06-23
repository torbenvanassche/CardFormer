class_name Deck
extends Node

var cards: Array[Button];

func add_card(card: CardData):
	var slot: Control = GUI.instance.get_open_ability_slot()
	cards.append(slot);
	slot.set_script(card.exec_script);
	slot.card_data = card;
	
	if slot.has_method("on_enter"):
		slot.on_enter();
	
func draw():
	return cards.pick_random();
