extends Control

@export var SteamNode : Control
@export var ENetNode : Control
@export var lobby : Lobby
@export var EnetInput : LineEdit
@export var SteamInput : LineEdit

func  _ready() -> void:
	if !SteamNode || !ENetNode || !Lobby || !EnetInput || !SteamInput:
		printerr("Missing Network Node")

func _on_steam_pressed() -> void:
	self.hide()
	GameState._setup_network("Steam")
	SteamNode.show()
	lobby.addres_input = SteamInput
	pass # Replace with function body.


func _on_e_net_pressed() -> void:
	self.hide()
	GameState._setup_network("ENet")
	ENetNode.show()
	lobby.addres_input = EnetInput
	pass # Replace with function body.
