extends Node

var	_player_scene = preload("res://scenes/player/player.tscn")
@export var _player_spawn_point: Node2D
var	_players_in_game: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	await  get_tree().process_frame

	#print(SteamManager.lobby_id)
	if GameState.is_hosting_game:
		multiplayer.peer_connected.connect(_client_connected)
		multiplayer.peer_disconnected.connect(_client_disconnected)
		if not OS.has_feature("dedicated_server"):
			_add_player_to_game(multiplayer.get_unique_id())
		pass # Replace with function body.

func _add_player_to_game(network_id):
	print("Adding player to game: ", str(network_id))
	
	var	player_to_add = _player_scene.instantiate()
	player_to_add.name = str(network_id);
	_ready_player(player_to_add)
	_players_in_game[network_id] = player_to_add
	_player_spawn_point.add_child(player_to_add)
	pass

func _remove_player_to_game(network_id):
	print("Removing player of game: ", str(network_id))
	if _players_in_game.has(network_id):
		var player_to_remove = _players_in_game[network_id]
		if player_to_remove:
			player_to_remove.queue_free()
			_players_in_game.erase(network_id)
	pass

func _ready_player(player: Player):
	player.position = Vector2(randi_range(-2, 2), randi_range(-2, 2))
	pass

func _client_connected(network_id):
	print("Client Connected ", str(network_id))
	_add_player_to_game(network_id)
	pass

func _client_disconnected(network_id):
	print("Client Disconnected ", str(network_id))
	_remove_player_to_game(network_id)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
