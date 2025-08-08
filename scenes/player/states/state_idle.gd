extends State

@export var player: CharacterBody2D
@export var inputs: Node
@onready var MOTION_SPEED = player.MOTION_SPEED
@export var vision: RayCast2D
@export var portrait: Control

func Enter():
	player.visible = true;
	player.modulate = Color(1,1,1)
	pass

func Update(_delta:float):
	if Input.is_action_just_pressed("space"):
		Craft()
		
	if player.weapon:
		if Input.is_action_just_pressed("left_click"):
			player.weapon.Fire()
	#if inputs:
	player.velocity = inputs.motion * MOTION_SPEED
	player.look_at(inputs.mouse_pos)
	update_camera_position()
	player.move_and_slide()
	pass
	
@export var max_camera_offset := 100.0  # Distância máxima que a câmera pode se afastar do player em direção ao mouse	

func update_camera_position():
	if not player.camera:
		return

	var mouse_global_pos = inputs.mouse_pos
	var player_pos = player.global_position

	var direction = (mouse_global_pos - player_pos).normalized()
	var distance = min((mouse_global_pos - player_pos).length(), max_camera_offset)

	var target_offset = direction * distance
	var target_camera_pos = player_pos + target_offset

	player.camera.global_position = player.camera.global_position.lerp(target_camera_pos, 0.1)  # suavemente segue
	_update_vision_frame()

func _update_vision_frame():
	if vision.is_colliding():
		var col = vision.get_collider()
		if col is Player:
			portrait.show()
	else:
		portrait.hide()
	pass

func Process_update(_delta:float):
	pass
	
func Exit():
	pass


var selected_object_type := ObjectRegistry.ObjectType.DEFAULT  # Default
func Craft():
	var offset := Vector2(50,0)
	var spawn_pos := player.global_position + offset
	var rot := player.rotation
	var estado := "1"
	ObjectRegistry.request_spawn.rpc_id(1,selected_object_type, spawn_pos, rot, estado)
	pass
