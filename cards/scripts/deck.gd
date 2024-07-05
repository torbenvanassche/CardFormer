class_name Deck
extends Node

var cards: Array[Card];

func add_card(card: Card):
	cards.append(card);
	Platformer.instance.player.hand.add_card(card);
