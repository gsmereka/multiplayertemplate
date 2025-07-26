class_name Player
extends CharacterBody2D

const MOTION_SPEED = 180.0

@export var synced_position: Vector2

# Estados possíveis do jogador
enum PlayerState { ALIVE, DYING, DEAD, GHOST }

# Estado sincronizado entre os jogadores (MultiplayerSpawner cuida disso)
@export var state: PlayerState = PlayerState.ALIVE

# Nós
@onready var inputs = $Inputs
@onready var camera = $Camera2D 
@onready var collision_shape = $CollisionShape2D

func _ready():
	print("Player spawned: ", name)

	# Define autoridade de rede para InputsSync com base no nome
	if str(name).is_valid_int():
		get_node("Inputs/InputsSync").set_multiplayer_authority(str(name).to_int())

	# Ativa a câmera apenas para o jogador local
	if str(multiplayer.get_unique_id()) == str(name):
		camera.enabled = true

func _physics_process(delta):
	var is_local_player = str(multiplayer.get_unique_id()) == str(name)

	print(state)
	# Atualiza input apenas para o player local
	if is_local_player:
		inputs.update()
		state = inputs.state;

	match state:
		PlayerState.ALIVE:
			velocity = inputs.motion * MOTION_SPEED
			move_and_slide()
			look_at(inputs.mouse_pos)
			if multiplayer.get_unique_id() == 1:
				print( "eu" + name + "estou vivo")
			visible = true

		PlayerState.DYING:
			velocity = Vector2.ZERO
			# Poderia adicionar animações ou efeitos aqui

		PlayerState.DEAD:
			velocity = Vector2.ZERO
			visible = false
			# Aguardar respawn

		PlayerState.GHOST:
			velocity = inputs.motion * (MOTION_SPEED * 0.5)
			move_and_slide()
			look_at(inputs.mouse_pos)

func _process(_delta):
	# Gerencia colisão de acordo com o estado
	match state:
		PlayerState.GHOST:
			collision_shape.disabled = true
		_:
			collision_shape.disabled = false

# ==============================
# Funções auxiliares de estado
# ==============================

func respawn(pos: Vector2):
	position = pos
	state = PlayerState.ALIVE

func set_ghost():
	state = PlayerState.GHOST
