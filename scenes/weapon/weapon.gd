extends Node2D

class_name Weapon

@onready var fire := $Fire
@onready var cast : RayCast2D = $RayCast2D
func Fire():
	fire.show()
	if cast:
		if cast.is_colliding():
			var col := cast.get_collider()
			if col is Player:
				col.take_damage.rpc_id(col.name.to_int())
			elif col.has_method("take_damage"):
				col.take_damage.rpc_id(1)
	await get_tree().create_timer(0.1).timeout
	fire.hide()
	
