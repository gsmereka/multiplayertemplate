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
		get_parent().change_state(self, "freeze")
	#if inputs:
	player.velocity = inputs.motion * MOTION_SPEED
	player.look_at(inputs.mouse_pos)
	player.move_and_slide()
	pass

func Process_update(_delta:float):
	pass
	
func Exit():
	pass
	
