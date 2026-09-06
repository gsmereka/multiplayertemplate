extends NetworkInterface

var peer: ENetMultiplayerPeer

func host_game(player_name: String):
	peer = ENetMultiplayerPeer.new()
	peer.create_server(10567)
	multiplayer.set_multiplayer_peer(peer)
	emit_signal("connected")

func join_game(_player_name: String, address: String = "127.0.0.1") -> void:
	#print("Criando ENet peer...")
	peer = ENetMultiplayerPeer.new()

	var error = peer.create_client(address, 10567)
	if error != OK:
		push_error("Erro ao criar cliente ENet: %s" % error)
		return
	multiplayer.set_multiplayer_peer(peer)

	#print("Aguardando conexão com o servidor...")
	await multiplayer.connected_to_server
	#print("Conectado com sucesso!")

	emit_signal("connected")
