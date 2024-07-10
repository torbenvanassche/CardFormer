class_name BattleHandler
extends Node

var _participants: Array[Node] = []

signal turn_end()

func _init(participants: Array[Node] = []):
	_participants = participants;
	pass
