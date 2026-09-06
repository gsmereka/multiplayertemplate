extends Control

const GAME_APP_ID := 480
const ENET_MENU_SCENE := "res://scenes/ENetLobbyMenu/enet_lobby_menu.tscn"

@onready var player_name_label: Label = %PlayerName
@onready var character_name_input: LineEdit = %CharacterName
@onready var status_label: Label = %Status
@onready var friend_lobbies: VBoxContainer = %FriendLobbies
@onready var refresh_button: Button = %RefreshButton
@onready var create_button: Button = %CreateButton

func _ready() -> void:
	GameState._setup_network("Steam")
	player_name_label.text = "Conectado como: %s" % SteamNetwork.steam_username
	character_name_input.placeholder_text = SteamNetwork.steam_username
	_refresh_friend_lobbies()

func _on_refresh_pressed() -> void:
	_refresh_friend_lobbies()

func _on_enet_pressed() -> void:
	get_tree().change_scene_to_file(ENET_MENU_SCENE)

func _on_create_pressed() -> void:
	if not SteamNetwork.running:
		status_label.text = "Steam não está disponível. Abra o cliente Steam e tente novamente."
		return
	if _character_name().is_empty():
		status_label.text = "Informe o nome do personagem antes de criar um lobby."
		return

	create_button.disabled = true
	status_label.text = "Criando lobby Steam..."
	GameState.host_game(_character_name())

func _refresh_friend_lobbies() -> void:
	_clear_lobby_list()

	if not SteamNetwork.running or not Steam.loggedOn():
		status_label.text = "Faça login na Steam para ver os lobbies dos seus amigos."
		return

	refresh_button.disabled = true
	status_label.text = "Procurando amigos em lobbies..."

	var found_lobbies := 0
	var seen_lobbies := {}
	var friend_count := Steam.getFriendCount(Steam.FRIEND_FLAG_IMMEDIATE)
	for index in range(max(friend_count, 0)):
		var friend_id := Steam.getFriendByIndex(index, Steam.FRIEND_FLAG_IMMEDIATE)
		var game_info: Dictionary = Steam.getFriendGamePlayed(friend_id)
		var lobby_id := int(game_info.get("lobby", 0))

		if int(game_info.get("id", 0)) != GAME_APP_ID or lobby_id == 0 or seen_lobbies.has(lobby_id):
			continue

		seen_lobbies[lobby_id] = true
		_add_friend_lobby(Steam.getFriendPersonaName(friend_id), lobby_id)
		found_lobbies += 1

	if found_lobbies == 0:
		status_label.text = "Nenhum amigo está em um lobby deste jogo no momento."
	else:
		status_label.text = "%d lobby(s) de amigo encontrados." % found_lobbies

	refresh_button.disabled = false

func _add_friend_lobby(friend_name: String, lobby_id: int) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)

	var details := Label.new()
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details.text = "%s\nLobby: %d" % [friend_name, lobby_id]
	details.add_theme_font_size_override("font_size", 20)
	row.add_child(details)

	var join_button := Button.new()
	join_button.text = "Entrar"
	join_button.custom_minimum_size = Vector2(120, 52)
	join_button.add_theme_font_size_override("font_size", 18)
	join_button.pressed.connect(_join_friend_lobby.bind(lobby_id))
	row.add_child(join_button)

	friend_lobbies.add_child(row)

func _join_friend_lobby(lobby_id: int) -> void:
	if _character_name().is_empty():
		status_label.text = "Informe o nome do personagem antes de entrar no lobby."
		return

	status_label.text = "Entrando no lobby %d..." % lobby_id
	refresh_button.disabled = true
	create_button.disabled = true
	GameState.join_game(_character_name(), str(lobby_id))

func _character_name() -> String:
	return character_name_input.text.strip_edges()

func _clear_lobby_list() -> void:
	for child in friend_lobbies.get_children():
		child.queue_free()
