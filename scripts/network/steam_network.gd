extends NetworkInterface

var peer: SteamMultiplayerPeer

func _ready():
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.join_requested.connect(_on_join_requested)

func host_game(player_name: String):
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 12)

func join_game(player_name: String, address: String = ""):
	var lobby_id = int(address)  # <- address vai conter o lobby_id (convertido de texto)
	Steam.joinLobby(lobby_id)

func _on_lobby_created(status: int, lobby_id: int):
	if status == 1:
		peer = SteamMultiplayerPeer.new()
		peer.create_host(0)  # corrigido: remove o segundo argumento
		multiplayer.set_multiplayer_peer(peer)
		emit_signal("connected")
	else:
		emit_signal("error", "Failed to create lobby.")

func _on_lobby_joined(lobby_id: int, _a, _b, response: int):
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		var id = Steam.getLobbyOwner(lobby_id)
		peer = SteamMultiplayerPeer.new()
		peer.create_client(id, 0)  # corrigido: só 2 args
		multiplayer.set_multiplayer_peer(peer)
		emit_signal("connected")
	else:
		emit_signal("error", "Failed to join Steam lobby.")
   # Código dentro do seu script principal (por exemplo, game.gd)

func _on_join_requested(lobby_id):
	Steam.joinLobby(lobby_id)
