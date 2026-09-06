extends Node

@export var network: NetworkInterface

var	is_hosting_game := false
var player_name: String
var game_loaded := false

signal game_started()
signal game_ended()
signal error_occurred(message)

func _setup_network(net : String):
	if network:
		if network.connected.is_connected(_on_connected):
			network.connected.disconnect(_on_connected)
		if network.error.is_connected(_on_error):
			network.error.disconnect(_on_error)
	if PlayerRegistry.players_updated.is_connected(_on_players_updated):
		PlayerRegistry.players_updated.disconnect(_on_players_updated)
	if multiplayer.peer_connected.is_connected(_on_peer_connected):
		multiplayer.peer_connected.disconnect(_on_peer_connected)
	if multiplayer.peer_disconnected.is_connected(_on_peer_disconnected):
		multiplayer.peer_disconnected.disconnect(_on_peer_disconnected)

	if net == "Steam":
		network = SteamNetwork
		network.setup()
	elif net == "Web":
		network = WebSocketNetwork
	else:
		network = EnetNetwork;
	if !network:
		printerr("Network Setup Incorrectly")
		return
	network.connected.connect(_on_connected)
	network.error.connect(_on_error)
	PlayerRegistry.players_updated.connect(_on_players_updated)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func host_game(new_player_name: String):
	is_hosting_game = true;
	player_name = new_player_name
	network.host_game(player_name)

func join_game(new_player_name: String, address: String = ""):
	player_name = new_player_name
	# MultiplayerSpawner replica nós assim que o servidor aceita a conexão.
	# Portanto, o cliente precisa ter a cena Game (e seus spawners) pronta
	# antes de criar o peer ENet/WebSocket/Steam.
	_load_game_once()
	while not get_tree().current_scene or get_tree().current_scene.scene_file_path != gameScene:
		await get_tree().process_frame
	network.join_game(player_name, address)

func _on_connected():
	# O host é a única fonte de verdade para a lista de jogadores. O cliente
	# já está na cena Game e solicita que o host registre seu nome.
	if multiplayer.is_server():
		PlayerRegistry.register_player(multiplayer.get_unique_id(), player_name)
		_broadcast_player_registry()
		_load_game_once()
	else:
		register_player.rpc_id(1, player_name)

func _on_error(message: String):
	print("Network error: ", message)
	emit_signal("error_occurred", message)

func _on_players_updated():
	print(PlayerRegistry.players)
	print("Player list updated.")

@rpc("any_peer", "reliable")
func register_player(name: String):
	# Esta RPC deve alterar dados somente no host. O ID vem da conexão, nunca
	# de um argumento enviado pelo cliente.
	if not multiplayer.is_server():
		return

	var id := multiplayer.get_remote_sender_id()
	if id <= 0:
		return
	if PlayerRegistry.players.has(id):
		return

	PlayerRegistry.register_player(id, name.strip_edges())
	_broadcast_player_registry()

func _on_peer_connected(id: int):
	pass

func _on_peer_disconnected(id: int):
	if multiplayer.is_server():
		PlayerRegistry.unregister_player(id)
		_broadcast_player_registry()

func _broadcast_player_registry() -> void:
	if multiplayer.is_server():
		sync_player_registry.rpc(PlayerRegistry.players, PlayerRegistry.players_points)

@rpc("authority", "reliable")
func sync_player_registry(players: Dictionary, points: Dictionary) -> void:
	PlayerRegistry.replace_roster(players, points)

const gameScene = "res://scenes/game/game.tscn"
const GameScene = preload(gameScene)
func	load_game():
	get_tree().call_deferred(&"change_scene_to_packed", preload(gameScene))

func _load_game_once() -> void:
	if game_loaded:
		return
	game_loaded = true
	load_game()
