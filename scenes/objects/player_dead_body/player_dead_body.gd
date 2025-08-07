extends Node2D

var type_level = "ground"
@export var _estado : String

#@rpc("call_local", "any_peer", "reliable")
func select_skin(estado: String):
	var index := int(estado) if estado.is_valid_int() else -1
	var children := $Sprites.get_children()

	# Se o índice for inválido, escolhe aleatoriamente um filho visível
	if index < 0 or index >= children.size():
		if children.size() > 0:
			var random_index = randi() % children.size()
			var random_child = children[random_index]
			if random_child is Node:
				random_child.visible = true
	else:
		var target_child = children[index]
		if target_child is Node:
			target_child.visible = true

func set_estado(estado: String) -> void:
	_estado = estado

func _ready() -> void:
	select_skin(_estado)
	

func get_level():
	return type_level
