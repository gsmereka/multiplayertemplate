extends Control

@onready var container: VBoxContainer = $HBoxContainer

func _ready() -> void:
	PlayerRegistry.players_updated.connect(_update_interface)
	_update_interface() # Atualiza interface no início, caso já haja players

func _update_interface() -> void:
	# Remove os labels existentes
	for child in container.get_children():
		child.queue_free()

	# Adiciona um label para cada jogador
	for id in PlayerRegistry.players.keys():
		var name = PlayerRegistry.players[id]
		var points = PlayerRegistry.players_points.get(id, 0) # usa 0 se não houver pontos
		var label = Label.new()
		label.text = "%s : %d" % [name, points]
		container.add_child(label)
