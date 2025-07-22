extends NetworkInterface

var peer: SteamMultiplayerPeer

func _ready():
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.run_callbacks()

func host_game(player_name: String):
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 12)
	# aguardar callback

func join_game(player_name: String, lobby_id: int):
	Steam.joinLobby(lobby_id)
	# aguardar callback

func _on_lobby_created(status: int, lobby_id: int):
	if status == 1:
		peer = SteamMultiplayerPeer.new()
		peer.create_host(0, [])
		multiplayer.set_multiplayer_peer(peer)
		emit_signal("connected")
	else:
		emit_signal("error", "Failed to create lobby.")

func _on_lobby_joined(lobby_id: int, _a, _b, response: int):
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		var id = Steam.getLobbyOwner(lobby_id)
		peer = SteamMultiplayerPeer.new()
		peer.create_client(id, 0, [])
		multiplayer.set_multiplayer_peer(peer)
		emit_signal("connected")
	else:
		emit_signal("error", "Failed to join Steam lobby.")
