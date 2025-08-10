extends State

@export var player: CharacterBody2D
@export var inputs: Node
@onready var MOTION_SPEED = player.MOTION_SPEED

var death_cam: Camera2D = null
var current_cam_index: int = 0
var alive_players: Array = []

func Enter():
	player.sprite.visible = false
	DropBody()
	player.collision_shape.disabled = true
	player.modulate = Color(1, 1, 1)
	player.camera.enabled = false

	_update_alive_players()
	_select_random_death_cam()

func Update(_delta: float):
	# Atualiza posição e rotação da vision
	if death_cam and current_cam_index < alive_players.size():
		var observed_player = alive_players[current_cam_index]
		if observed_player:
			player.vision.global_position = observed_player.global_position
			player.vision.rotation = observed_player.rotation

	if Input.is_action_just_pressed("space"):
		Revive()

	if Input.is_action_just_pressed("left_click"):
		_update_alive_players()

		if alive_players.size() == 0:
			if death_cam:
				death_cam.enabled = false
				death_cam = null
			return

		if death_cam:
			death_cam.enabled = false

		current_cam_index = (current_cam_index + 1) % alive_players.size()
		var next_player = alive_players[current_cam_index]
		death_cam = next_player.camera
		if death_cam:
			death_cam.enabled = true

func Exit():
	pass

func Revive():
	player.teleport_to_random_spawn_point()
	player.sprite.visible = true
	player.collision_shape.disabled = false
	player.states.change_state(self, "idle")
	if death_cam:
		death_cam.enabled = false
		death_cam = null
	player.camera.enabled = true

	# Vision volta a seguir o próprio player
	player.vision.global_position = player.global_position
	player.vision.rotation = player.rotation

func _update_alive_players():
	alive_players.clear()
	for child in player.get_parent().get_children():
		if child is Player:
			var cam = child.camera
			if cam and cam is Camera2D:
				alive_players.append(child)

func _select_random_death_cam():
	if alive_players.size() > 0:
		current_cam_index = randi() % alive_players.size()
		var chosen_player = alive_players[current_cam_index]
		death_cam = chosen_player.camera
		if death_cam:
			death_cam.enabled = true
	else:
		death_cam = null

func DropBody():
	var spawn_pos := player.global_position
	var rot := player.rotation
	ObjectRegistry.request_spawn.rpc_id(1, ObjectRegistry.ObjectType.BODY, spawn_pos, rot, str(randi() % 8))
