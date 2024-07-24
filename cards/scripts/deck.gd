class_name Deck
extends Node

var cards: Array[Card];
var drawn: Array[Card];

func add_card(card: Card):
	cards.append(card);
	
func draw_card():
	var c = cards.pick_random();
	cards.erase(c);
	drawn.append(c);
	return c;

func is_empty():
	return cards.size() == 0;
