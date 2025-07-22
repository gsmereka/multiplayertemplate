extends Node

class_name PlayerRegistry

var players := {}
signal players_updated()

func register_player(id: int, name: String):
	players[id] = _make_string_unique(name)
	emit_signal("players_updated")

func unregister_player(id: int):
	players.erase(id)
	emit_signal("players_updated")

func _make_string_unique(name: String) -> String:
	var unique_name = name
	var counter = 1
	while players.values().has(unique_name):
		counter += 1
		unique_name = name + " " + str(counter)
	return unique_name
