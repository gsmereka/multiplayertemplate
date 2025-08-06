extends RigidBody2D

class_name ObjectClass

@export var hp = 3

@rpc("any_peer", "reliable", "call_local")
func take_damage():
	if hp > 0:
		hp-= 1
	if hp <= 0:
		if multiplayer.is_server():
			queue_free()
