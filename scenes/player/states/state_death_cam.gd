extends State

@export var player: CharacterBody2D
@export var inputs: Node
@onready var MOTION_SPEED = player.MOTION_SPEED

var death_cam: Camera2D = null
var other_cameras: Array = []
var current_cam_index: int = 0

func Enter():
	player.visible = false
	player.collision_shape.disabled = true
	player.modulate = Color(1,1,1)
	# Desativa câmera do player morto
	player.camera.enabled = false

	# Pega todas as câmeras dos outros players no mesmo nó pai, ignorando a do próprio player
	other_cameras.clear()
	for child in player.get_parent().get_children():
		if child != player and child.camera:
			var cam = child.camera
			if cam is Camera2D:
				other_cameras.append(cam)
	
	if other_cameras.size() > 0:
		current_cam_index = randi() % other_cameras.size()
		death_cam = other_cameras[current_cam_index]
		death_cam.enabled = true
	else:
		death_cam = null

func Update(_delta: float):
	if Input.is_action_just_pressed("space"):
		Revive()

	if death_cam and Input.is_action_just_pressed("left_click"):
		# Trocar para próxima câmera na lista
		death_cam.enabled = false
		current_cam_index = (current_cam_index + 1) % other_cameras.size()
		death_cam = other_cameras[current_cam_index]
		death_cam.enabled = true

func Exit():
	# Reativa a câmera do player morto
	player.camera.enabled = true
	# Desativa a câmera de espectador atual, se houver
	if death_cam:
		death_cam.enabled = false
		death_cam = null

func Revive():
	player.global_position = player.get_parent().global_position
	player.visible = true
	player.collision_shape.disabled = false
	player.states.change_state(self, "idle")
