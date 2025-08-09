extends Node

@onready var groundS := $MultiplayerSpawnerGround
@onready var topS := $MultiplayerSpawnerTop

func _ready() -> void:
	ObjectRegistry.node_spawner_ground = $"../Ground/ObjectsGroundSpawn"
	ObjectRegistry.node_spawner_top = $"../Top/ObjectsTopSpawn"
	pass
