extends Node

var	_player_scene = preload("res://scenes/player/player.tscn")
@export var _player_spawn_point: Node2D
var	_players_in_game: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	await  get_tree().process_frame

	if GameState.is_hosting_game:
		multiplayer.peer_connected.connect(_client_connected)
		multiplayer.peer_disconnected.connect(_client_disconnected)
		for network_id in PlayerRegistry.players.keys():
			_add_player_to_game(network_id)
		pass

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

const next_scene = preload("res://scenes/game/game.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameState.is_hosting_game and Input.is_key_pressed(KEY_SPACE):
		recharge_scene_for_all.rpc()

@rpc("call_local", "any_peer")
func change_scene_for_all():
	var scene = load("res://scenes/game/game.tscn")
	if scene:
		get_tree().change_scene_to_packed(scene)
	else:
		print("Erro: cena não encontrada!")

@rpc("call_local", "any_peer")
func recharge_scene_for_all():
	var current_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(current_scene_path)
