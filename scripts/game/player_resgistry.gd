extends Node
signal players_updated()

var players := {}
var players_points := {}

# PlayerRegistry.gd
func register_player(id: int, name: String):
	players[id] = _make_string_unique(name)
	players_points[id] = 0 # inicializa pontuação
	emit_signal("players_updated")

func unregister_player(id: int):
	players.erase(id)
	players_points.erase(id)
	emit_signal("players_updated")

func replace_roster(new_players: Dictionary, new_points: Dictionary) -> void:
	players = new_players.duplicate()
	players_points = new_points.duplicate()
	emit_signal("players_updated")

func _make_string_unique(name2: String) -> String:
	var unique_name = name2
	var counter = 1
	while players.values().has(unique_name):
		counter += 1
		unique_name = name2 + " " + str(counter)
	return unique_name

@rpc("any_peer", "call_local")
func update_points(id : int, clear : bool = false):
	if clear:
		players_points.clear()
		emit_signal("players_updated")
		return
	if id != 0:
		if PlayerRegistry.players_points.has(id):
			PlayerRegistry.players_points[id] += 1
		else:
			PlayerRegistry.players_points[id] = 1
		emit_signal("players_updated")

@rpc("any_peer", "call_local", "reliable")
func update_points_to_new_player(points_data: Dictionary) -> void:
	# Atualiza o dicionário local de pontos com os dados recebidos
	players_points.clear()
	for pid in points_data.keys():
		players_points[pid] = points_data[pid]

	# Dispara o sinal para atualizar a interface
	emit_signal("players_updated")
