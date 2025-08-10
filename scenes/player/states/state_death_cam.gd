extends State

@export var player: CharacterBody2D
@export var inputs: Node
@onready var MOTION_SPEED = player.MOTION_SPEED

var alive_players: Array = []
var current_player: Player = null

func Enter():
	# Esconde e desativa o player atual
	player.sprite.hide()
	player.vision.hide()
	DropBody()
	player.collision_shape.disabled = true
	player.modulate = Color(1, 1, 1)
	player.camera.enabled = false

	_update_alive_players()
	_select_random_alive_player()

func Update(_delta: float):
	if Input.is_action_just_pressed("space"):
		Revive()

	if Input.is_action_just_pressed("left_click"):
		_cycle_next_alive_player()

func Exit():
	pass

func Revive():
	player.teleport_to_random_spawn_point()
	player.sprite.show()
	player.collision_shape.disabled = false
	player.states.change_state(self, "idle")

	if current_player and current_player.camera:
		current_player.vision.hide()
		current_player.camera.enabled = false
	current_player = null
	player.vision.show()
	player.camera.enabled = true

func _update_alive_players():
	alive_players.clear()
	for child in player.get_parent().get_children():
		if child is Player:
			if child.camera and child.camera is Camera2D:
				alive_players.append(child)

func _select_random_alive_player():
	if alive_players.size() > 0:
		var random_index = randi() % alive_players.size()
		_set_current_player(alive_players[random_index])
	else:
		_set_current_player(null)

func _cycle_next_alive_player():
	_update_alive_players()

	if alive_players.size() == 0:
		_set_current_player(null)
		return

	var current_index = alive_players.find(current_player)
	if current_index == -1:
		current_index = 0
	else:
		current_index = (current_index + 1) % alive_players.size()

	_set_current_player(alive_players[current_index])

func _set_current_player(new_player: Player):
	# Desativa câmera do jogador anterior
	if current_player and current_player.camera:
		current_player.vision.hide()
		current_player.camera.enabled = false

	current_player = new_player

	# Ativa câmera do novo jogador observado
	if current_player and current_player.camera:
		current_player.vision.show()
		current_player.camera.enabled = true

func DropBody():
	var spawn_pos := player.global_position
	var rot := player.rotation
	ObjectRegistry.request_spawn.rpc_id(
		1,
		ObjectRegistry.ObjectType.BODY,
		spawn_pos,
		rot,
		str(randi() % 8)
	)
