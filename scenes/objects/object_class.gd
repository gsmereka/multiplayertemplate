extends StaticBody2D

class_name ObjectClass

var type_level : String = "top"
@export var hp = 3

@rpc("any_peer", "reliable", "call_local")
func take_damage():
	
	if hp > 0:
		hp-= 1
	if hp <= 0:
		queue_free()
