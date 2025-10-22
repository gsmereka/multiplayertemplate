extends NetworkInterface

var peer: WebSocketMultiplayerPeer

func host_game(player_name: String):
	peer = WebSocketMultiplayerPeer.new()
	var err = peer.create_server(10567)  # Porta fixa como você pediu

	if err != OK:
		push_error("Erro ao iniciar servidor WebSocket: %s" % err)
		return

	multiplayer.set_multiplayer_peer(peer)
	emit_signal("connected")


func join_game(_player_name: String, address: String = "127.0.0.1") -> void:
	peer = WebSocketMultiplayerPeer.new()
	var url = "ws://%s:10567" % address

	var err = peer.create_client(url)

	if err != OK:
		push_error("Erro ao conectar ao servidor WebSocket: %s" % err)
		return

	multiplayer.set_multiplayer_peer(peer)

	await multiplayer.connected_to_server
	emit_signal("connected")
