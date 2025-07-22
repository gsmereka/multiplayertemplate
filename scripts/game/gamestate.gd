extends Node

@export var network: NetworkInterface

var player_name: String  # <--- agora declarado

signal game_started()
signal game_ended()
signal error_occurred(message)

func _ready():
	network = EnetNetwork;
	network.connected.connect(_on_connected)
	network.error.connect(_on_error)
	PlayerRegistry.players_updated.connect(_on_players_updated)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func host_game(new_player_name: String):
	player_name = new_player_name
	network.host_game(player_name)

func join_game(new_player_name: String, address: String = ""):
	player_name = new_player_name
	network.join_game(player_name, address)

func _on_connected():
	PlayerRegistry.register_player(multiplayer.get_unique_id(), player_name)

func _on_error(message: String):
	print("Network error: ", message)
	emit_signal("error_occurred", message)

func _on_players_updated():
	print("Player list updated.")

@rpc("call_local", "any_peer")
func register_player(name: String):
	var id = multiplayer.get_remote_sender_id()
	PlayerRegistry.register_player(id, name)

func _on_peer_connected(id: int):
	register_player.rpc_id(id, player_name)

func _on_peer_disconnected(id: int):
	PlayerRegistry.unregister_player(id)
