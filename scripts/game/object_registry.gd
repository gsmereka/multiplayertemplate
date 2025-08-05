extends Node
signal objects_updated()

var node_spawner : Node
# Enum para tipos de objeto
enum ObjectType {
	DEFAULT,
	TREE,
	CRATE
}

# Dicionário com as cenas
const OBJECT_SCENES := {
	ObjectType.DEFAULT: preload("res://scenes/objects/object.tscn"),
	ObjectType.TREE: preload("res://scenes/objects/object.tscn"),
	ObjectType.CRATE: preload("res://scenes/objects/object.tscn")
}

# Lista de objetos instanciados (dados)
var objects: Array = []

func _ready():
	if Engine.is_editor_hint():
		return
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

# Instancia localmente e registra
@rpc("call_local", "any_peer")
func request_spawn(tipo_objeto: int, position: Vector2, rotation_degrees: float, estado: String = ""):
	if not OBJECT_SCENES.has(tipo_objeto):
		push_error("Tipo de objeto inválido: %s" % tipo_objeto)
		return

	var object_data = {
		"tipo": tipo_objeto,
		"pos": position,
		"rot": rotation_degrees,
		"estado": estado
	}

	spawn_object(object_data)
	register_object(object_data)

func register_object(data: Dictionary):
	objects.append(data)
	emit_signal("objects_updated")

func spawn_object(data: Dictionary):
	var scene: PackedScene = OBJECT_SCENES[data["tipo"]]
	var instance = scene.instantiate()
	instance.global_position = data["pos"]
	instance.rotation = data["rot"]
	
	if instance.has_method("set_estado"):
		instance.set_estado(data["estado"])

	if !node_spawner:
		get_tree().current_scene.add_child(instance)
	else:
		node_spawner.add_child(instance, true)

func _on_peer_disconnected(id: int):
	# Você pode limpar objetos associados ao peer aqui, se quiser
	pass

# Utilidade para uso externo
static func get_scene_from_type(tipo: int) -> PackedScene:
	return OBJECT_SCENES.get(tipo, null)
