extends RigidBody2D

class_name ObjectClass

@export var hp = 3

@rpc("any_peer", "call_local")
func take_damage():
	if !multiplayer.is_server():
		return
	if hp > 0:
		hp-= 1
	if hp <= 0:
		queue_free()
