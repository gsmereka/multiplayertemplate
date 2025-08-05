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
	#if inputs:
	player.velocity = inputs.motion * MOTION_SPEED
	player.look_at(inputs.mouse_pos)
	player.move_and_slide()
	pass

func Process_update(_delta:float):
	pass
	
func Exit():
	pass

func Craft():
	var node = load("res://scenes/objects/object.tscn")
	var node2 = node.instantiate()
	node2.global_position = player.global_position
	node2.global_position.x += 50
	var manager = player.get_parent().get_parent().get_node("ObjectsManager")
	if manager:
		if multiplayer.is_server():
			manager.set_to_spawn(node2)
		else:
			manager.set_to_spawn.rpc_id(1, node2)
	print(manager)
	pass
