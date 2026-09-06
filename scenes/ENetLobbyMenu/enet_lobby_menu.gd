extends Control

const STEAM_MENU_SCENE := "res://scenes/SteamLobbyMenu/steam_lobby_menu.tscn"

@onready var character_name_input: LineEdit = %CharacterName
@onready var host_address_input: LineEdit = %HostAddress
@onready var status_label: Label = %Status
@onready var host_button: Button = %HostButton
@onready var join_button: Button = %JoinButton

func _ready() -> void:
	GameState._setup_network("ENet")

func _on_host_pressed() -> void:
	if _character_name().is_empty():
		status_label.text = "Informe o nome do personagem antes de criar uma partida."
		return

	_disable_actions()
	status_label.text = "Criando servidor ENet na porta 10567..."
	GameState.host_game(_character_name())

func _on_join_pressed() -> void:
	if _character_name().is_empty():
		status_label.text = "Informe o nome do personagem antes de entrar na partida."
		return

	var address := host_address_input.text.strip_edges()
	if address.is_empty():
		address = "127.0.0.1"

	_disable_actions()
	status_label.text = "Conectando a %s:10567..." % address
	GameState.join_game(_character_name(), address)

func _on_steam_pressed() -> void:
	get_tree().change_scene_to_file(STEAM_MENU_SCENE)

func _character_name() -> String:
	return character_name_input.text.strip_edges()

func _disable_actions() -> void:
	host_button.disabled = true
	join_button.disabled = true
