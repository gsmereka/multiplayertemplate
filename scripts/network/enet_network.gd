extends NetworkInterface

var peer: ENetMultiplayerPeer

func host_game(player_name: String):
	peer = ENetMultiplayerPeer.new()
	peer.create_server(10567)
	multiplayer.set_multiplayer_peer(peer)
	emit_signal("connected")

func join_game(player_name: String, address: String):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, 10567)
	multiplayer.set_multiplayer_peer(peer)
	await multiplayer.connected_to_server
	emit_signal("connected")
