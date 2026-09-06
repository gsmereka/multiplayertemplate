extends NetworkInterface

var peer: SteamMultiplayerPeer


var running : bool = false
var steam_id := 0
var steam_username : String = ""

func _process(delta: float) -> void:
	if running:
		Steam.run_callbacks()

func setup():
	if running:
		return
	running = true
	Steam.steamInitEx(true, 480)
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.join_requested.connect(_on_join_requested)
	print("Steam running: ", Steam.isSteamRunning())
	print("User logged in: ", Steam.loggedOn())
	print("Steam name: ", Steam.getPersonaName())
	print("Matchmaking disponível: ", Steam.createLobby != null)

func host_game(_player_name: String):
	print("Before createLobby")
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 6)
	print("After createLobby")

func join_game(_player_name: String, address: String = ""):
	var lobby_id = int(address)  # <- address vai conter o lobby_id (convertido de texto)
	Steam.joinLobby(lobby_id)

func _on_lobby_created(status: int, lobby_id: int):
	print("status + " + str(status))
	if status == 1:
		print("✅ Lobby criado com sucesso")
		print("Lobby ID: ", lobby_id)
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName(), "'s Spectabulous Test Server"))
		print("✅ Nome do lobby definido")

		print("🔧 Criando SteamMultiplayerPeer")
		peer = SteamMultiplayerPeer.new()

		print("🔧 Chamando peer.create_host(0)")
		peer.create_host(0)

		print("🔧 Definindo multiplayer.set_multiplayer_peer")
		multiplayer.set_multiplayer_peer(peer)

		print("📡 Emitindo sinal 'connected'")
		emit_signal("connected")
	else:
		print("❌ Falha ao criar lobby")
		emit_signal("error", "Failed to create lobby.")


func _on_lobby_joined(lobby_id: int, _a, _b, response: int):
	if GameState.is_hosting_game:
		return
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		var id = Steam.getLobbyOwner(lobby_id)
		peer = SteamMultiplayerPeer.new()
		peer.create_client(id, 0)  # corrigido: só 2 args
		multiplayer.set_multiplayer_peer(peer)
		emit_signal("connected")
	else:
		emit_signal("error", "Failed to join Steam lobby.")
   # Código dentro do seu script principal (por exemplo, game.gd)

func _on_join_requested(lobby_id: int, _steam_id: int):
	Steam.joinLobby(lobby_id)
