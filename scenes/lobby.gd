extends Control

#@onready var player_list_ui = $SteamPlayers/List

func _ready():
	PlayerRegistry.players_updated.connect(_refresh_players)
	GameState.error_occurred.connect(_on_error)
	
func _refresh_players():
	#player_list_ui.clear()
	#for name in PlayerRegistry.players.values():
		#player_list_ui.add_item(name)
	pass

func _on_host_pressed():
	GameState.host_game($Name.text)

func _on_join_pressed():
	var addr : String = $TabContainer/ENet/Players/MarginContainer/VBoxContainer/Address.text
	if addr.is_empty():
		addr = "127.0.0.1"
	GameState.join_game($Name.text, addr)



func _on_error(message: String):
	print("Erro:", message)
