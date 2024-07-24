class_name Deck
extends Node

var cards: Array[Card];
var drawn: Array[Card];

signal deck_changed();

func add_card(card: Card):
	cards.append(card);
	deck_changed.emit();
	
func draw_card():
	var c = cards.pick_random();
	cards.erase(c);
	drawn.append(c);
	deck_changed.emit();
	return c;

func is_empty():
	return cards.size() == 0;
