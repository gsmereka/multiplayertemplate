extends Control

class_name Lobby

@export var addres_input : LineEdit = null
@export var name_input : LineEdit

func _ready():
	PlayerRegistry.players_updated.connect(_refresh_players)
	GameState.error_occurred.connect(_on_error)
	
func _refresh_players():
	pass

func _on_host_pressed():
	self.hide()
	GameState.host_game(name_input.text)

func _on_join_pressed():
	var addr : String = "127.0.0.1"
	if addres_input:
		addr = addres_input.text
	if addr == "":
		addr = "127.0.0.1"
	GameState.join_game(name_input.text, addr)

func _on_error(message: String):
	printerr("Erro:", message)
