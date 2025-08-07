extends State

@export var player: CharacterBody2D
@export var inputs: Node
@onready var MOTION_SPEED = player.MOTION_SPEED

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
	player.move_and_slide()
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
