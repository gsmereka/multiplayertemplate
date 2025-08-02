class_name Player
extends CharacterBody2D

const MOTION_SPEED = 180.0
@export var is_local_player := false
@export var color : Color
# Nós
@onready var inputs = $Inputs
@onready var states = $States
@onready var camera = $Camera2D 
@onready var collision_shape = $CollisionShape2D

func _ready():
	if is_local_player:
		camera.enabled = true
		return
	if str(name).is_valid_int():
		is_local_player = str(multiplayer.get_unique_id()) == str(name)
		states.set_multiplayer_authority(str(name).to_int())
		inputs.set_multiplayer_authority(str(name).to_int())
	if is_local_player:
		camera.enabled = true

func _physics_process(delta):
	if is_local_player:
		inputs.update()
