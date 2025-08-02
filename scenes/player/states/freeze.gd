extends State

@export var player: CharacterBody2D
@onready var inputs = player.inputs
@onready var MOTION_SPEED = player.MOTION_SPEED

func Enter():
	player.visible = true;
	player.modulate = player.color
	pass
	
func Update(_delta:float):
	if Input.is_action_just_pressed("space"):
		get_parent().change_state(self, "idle")
	return
	player.velocity = inputs.motion * MOTION_SPEED
	player.move_and_slide()
	player.look_at(inputs.mouse_pos)
	pass

func Process_update(_delta:float):
	pass
	
func Exit():
	pass
	
