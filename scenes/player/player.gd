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
@export var loadingScene : Node
@export var weapon : Weapon

func _enter_tree():
	is_local_player = is_multiplayer_authority()
	if is_local_player:
		canvas.visible = true
		camera.enabled = true

func _ready() -> void:
	states.force_change_state("freeze")
	if is_local_player:
		_setup_player()

func _setup_player():
	await get_tree().create_timer(1.1 ).timeout
	global_position = get_parent().global_position
	states.force_change_state("idle")
	pass

func _physics_process(delta):
	if is_local_player:
		inputs.update()

var hp = 3
@rpc("any_peer", "call_local")
func take_damage():
	var passo : float = 0.1
	var cor_atual = modulate

	# Diminui os valores R, G e B, mas garante que não fiquem abaixo de 0
	cor_atual.r = max(cor_atual.r - passo, 0)
	cor_atual.g = max(cor_atual.g - passo, 0)
	cor_atual.b = max(cor_atual.b - passo, 0)
	
	hp -= 1
	if hp <= 0:
		states.force_change_state("death_cam")
		hp = 3
	# Aplica a nova cor
	modulate = cor_atual
	
#func _physics_process(delta):
	#if Input.is_action_just_pressed("space") && is_local_player:
		#global_position = get_parent().global_position
	#if is_local_player:
		#inputs.update()
