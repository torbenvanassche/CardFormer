class_name Deck
extends Node

var cards: Array[Card];
var current_cards: Array[Card];
@export var initial_cards: Array[CardData];

signal deck_changed();

func create() -> void:
	for card_data in initial_cards:
		add_card(Card.new(card_data))
	current_cards = cards.duplicate();
	deck_changed.emit();
	
func remove_card(card_data: CardData):
	current_cards.erase(card_data);
	cards.erase(card_data);
	deck_changed.emit();

func add_card(card: Card):
	current_cards.append(card);
	cards.append(card);
	deck_changed.emit();
	
func draw_card():
	var c = current_cards.pick_random();
	current_cards.erase(c);
	deck_changed.emit();
	return c;

func is_empty():
	return current_cards.size() == 0;
	
func reset_deck():
	current_cards = cards.duplicate();
