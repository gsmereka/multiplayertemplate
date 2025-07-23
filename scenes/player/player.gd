class_name Player
extends CharacterBody2D

const MOTION_SPEED = 180.0

@export var synced_position : Vector2

@onready
var inputs = $Inputs

func _ready():
	print("Original Player spawned")
	if str(name).is_valid_int():
		get_node("Inputs/InputsSync").set_multiplayer_authority(str(name).to_int())
		pass


func _physics_process(delta):
	#inputs.update()
	#velocity = inputs.motion * MOTION_SPEED
	#move_and_slide()
	#look_at(inputs.mouse_pos)
	#return
	#print("Multiplayer Peer: ", multiplayer.multiplayer_peer)
	#if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
	if str(multiplayer.get_unique_id()) == str(name):
		# The client which this player represent will update the controls state, and notify it to everyone.
		inputs.update()

	#if multiplayer.multiplayer_peer == null or is_multiplayer_authority():
	if is_multiplayer_authority():# Everybody runs physics. I.e. clients tries to predict where they will be during the next frame.
		velocity = inputs.motion * MOTION_SPEED
		move_and_slide()
		look_at(inputs.mouse_pos)
