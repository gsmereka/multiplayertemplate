extends Node
signal players_updated()

var players := {}
var players_points := {}

# PlayerRegistry.gd
func register_player(id: int, name: String):
	players[id] = _make_string_unique(name)
	players_points[id] = 0 # inicializa pontuação
	emit_signal("players_updated")


func register_player_points(id: int, name: String):
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
