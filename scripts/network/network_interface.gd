extends Node

class_name NetworkInterface
signal connected()
signal disconnected()
signal error(message : String)

func host_game(player_name: String) -> void:
	pass

func join_game(player_name: String, address: String = "") -> void:
	pass

func send_player_name(name: String) -> void:
	pass
