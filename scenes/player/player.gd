class_name Player
extends CharacterBody2D

const MOTION_SPEED = 180.0
@export var is_local_player := false
@export var color : Color
# Nós
@export var inputs : Node
@export var states : Node
@export var camera : Camera2D 
@export var collision_shape : CollisionShape2D
@export var canvas : CanvasLayer
@export var interface : Control

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	is_local_player = is_multiplayer_authority()
	if is_local_player:
		hide()
		canvas.visible = true
		camera.enabled = true

func _ready() -> void:
	if is_local_player:
		_setup_player()

func _setup_player():
	await get_tree().create_timer(2.0).timeout
	global_position = get_parent().global_position
	$CanvasLayer/Control/Loading.hide()
	show()
	pass

func _physics_process(delta):
	if is_local_player:
		inputs.update()

#func _physics_process(delta):
	#if Input.is_action_just_pressed("space") && is_local_player:
		#global_position = get_parent().global_position
	#if is_local_player:
		#inputs.update()
