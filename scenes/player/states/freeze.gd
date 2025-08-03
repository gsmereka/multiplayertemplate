extends State

@export var player: Player
@onready var inputs = player.inputs
@onready var MOTION_SPEED = player.MOTION_SPEED

func Enter():
	player.visible = false;
	player.collision_shape.disabled = true
	player.loadingScene.show()
	pass
	
func Update(_delta:float):
	pass

func Process_update(_delta:float):
	pass
	
func Exit():
	player.visible = true;
	player.collision_shape.disabled = false
	player.loadingScene.hide()
	pass
	
