extends Node

@onready var groundS := $MultiplayerSpawnerGround
@onready var topS := $MultiplayerSpawnerTop

func _ready() -> void:
	ObjectRegistry.node_spawner = $"../Ground/ObjectsGroundSpawn"
	groundS.spawn_function = spawn_object
	topS.spawn_function = spawn_object
	pass

@rpc("any_peer","call_remote")
func set_to_spawn(node : Node, on_ground : bool = true) -> void:
	if on_ground:
		groundS.spawn(node)
	else:
		topS.spawn()
	pass

func spawn_object(node : Node) -> Node:
	return node
