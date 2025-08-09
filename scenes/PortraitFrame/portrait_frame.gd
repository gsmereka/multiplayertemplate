extends Control

class_name PortraitFrame

const heart_icon := preload("res://scenes/PortraitFrame/heart_icon.tscn")
const portrait_texture := preload("res://assets/player/portrait.png")

@export var frame: TextureRect
@export var frame_name: Label
@export var hp_container: VBoxContainer

var observed_player: Player
var last_hp: int = -9999 # Valor inicial "garantido" diferente

func set_heart(hp: int) -> void:
	# Limpa os ícones anteriores
	for child in hp_container.get_children():
		child.queue_free()

	# Protege contra HP negativo
	var clamped_hp = max(hp, 0)

	# Adiciona os corações
	for i in range(clamped_hp):
		var heart = heart_icon.instantiate()
		hp_container.add_child(heart)

func _process(delta: float) -> void:
	if observed_player != null:
		var current_hp = observed_player.hp
		if current_hp != last_hp:
			last_hp = current_hp
			set_heart(current_hp)

func show_info(col: Player) -> void:
	var player_id = col.name.to_int()
	if PlayerRegistry.players.has(player_id):
		frame_name.text = PlayerRegistry.players[player_id]
		frame.texture = portrait_texture
		observed_player = col
		last_hp = -9999 # Reset para forçar primeira atualização
		show()
	else:
		push_error("ID de jogador inválido: %d" % player_id)

func hide_info() -> void:
	observed_player = null
	hide()
