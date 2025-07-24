class_name Player
extends CharacterBody2D

const MOTION_SPEED = 180.0

@export var synced_position : Vector2

@onready var inputs = $Inputs
@onready var camera = $Camera2D

func _ready():
	await get_tree().process_frame
	print("Player spawned: ", name)

	if str(name).is_valid_int():
		get_node("Inputs/InputsSync").set_multiplayer_authority(str(name).to_int())

	## Habilita a câmera apenas se este player é o dono (auts
	#if is_multiplayer_authority():
		#camera.enabled = true
		#print(name + " yes")
	#else:
		#camera.enabled = false
		#print(name + " no")


func _physics_process(delta):
	if str(multiplayer.get_unique_id()) == str(name):
		inputs.update()
		$Camera2D.enabled = true

	#if is_multiplayer_authority():
	velocity = inputs.motion * MOTION_SPEED
	move_and_slide()
	look_at(inputs.mouse_pos)
