extends Node

@export var player_registry: PlayerRegistry
@export var network: NetworkInterface

signal game_started()
signal game_ended()
signal error_occurred(message)

func _ready():
	network.connected.connect(_on_connected)
	network.error.connect(_on_error)
	player_registry.players_updated.connect(_on_players_updated)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func host_game(player_name: String):
	network.host_game(player_name)

func join_game(player_name: String, address: String = ""):
	network.join_game(player_name, address)

func _on_connected():
	player_registry.register_player(multiplayer.get_unique_id(), player_name)

@rpc("call_local", "any_peer")
func register_player(name: String):
	var id = multiplayer.get_remote_sender_id()
	player_registry.register_player(id, name)

func _on_peer_connected(id: int):
	register_player.rpc_id(id, player_name)

func _on_peer_disconnected(id: int):
	player_registry.unregister_player(id)
