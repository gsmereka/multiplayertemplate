extends Node

@export
var motion := Vector2():
	set(value):
		# This will be sent by players, make sure values are within limits.
		motion = clamp(value, Vector2(-1, -1), Vector2(1, 1))
@export var mouse_pos := Vector2.ZERO

@export var state = Player.PlayerState.ALIVE

func update():
	var m = Vector2()
	if Input.is_action_pressed("left"):
		m += Vector2(-1, 0)
	if Input.is_action_pressed("right"):
		m += Vector2(1, 0)
	if Input.is_action_pressed("up"):
		m += Vector2(0, -1)
	if Input.is_action_pressed("down"):
		m += Vector2(0, 1)
	mouse_pos = get_parent().get_global_mouse_position()
	motion = m
	if Input.is_action_just_pressed("space"):
		die()


func die():
	if state != Player.PlayerState.DEAD:
		state = Player.PlayerState.DYING
		await get_tree().create_timer(1.0).timeout
		state = Player.PlayerState.DEAD
		await get_tree().create_timer(2.0).timeout
		state = Player.PlayerState.ALIVE
