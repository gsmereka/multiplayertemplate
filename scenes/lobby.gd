extends Control

@onready var player_list_ui = $SteamPlayers/List

func _ready():
	GameState.player_registry.players_updated.connect(_refresh_players)
	GameState.error_occurred.connect(_on_error)
	
func _refresh_players():
	player_list_ui.clear()
	for name in GameState.player_registry.players.values():
		player_list_ui.add_item(name)

func _on_host_pressed():
	GameState.host_game($PlayerName.text)

func _on_join_pressed():
	var addr = $ENetAddressEntry.text
	GameState.join_game($PlayerName.text, addr)

func _on_error(message: String):
	print("Erro:", message)
