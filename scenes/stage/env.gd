extends Node2D

@export var daylight : ColorRect
@export var Shadow : ColorRect
var day_duration := 60.0  # duração total do ciclo em segundos
var elapsed_time := 0.0

# Cores do ciclo
@export var night_color := Color(0, 0, 0)
@export var dawn_dusk_color := Color(1.0, 0.5, 0.2)  # Laranja suave
@export var day_color := Color(1, 1, 1)  # Branco

func _process(delta: float) -> void:
	if !multiplayer.is_server():
		return
	elapsed_time = fmod(elapsed_time + delta, day_duration)
	var t = elapsed_time / day_duration

	var shadow_alpha := 0.0  # transparência inicial do shadow
	
	# Divida o tempo em 4 fases de 15 segundos cada
	if t < 0.25:
		# Amanhecer: escuro -> laranja
		var phase_t = t / 0.25
		daylight.color = night_color.lerp(dawn_dusk_color, phase_t)
		shadow_alpha = lerp(1.0, 0.3, phase_t) # noite -> menos sombra
	elif t < 0.5:
		# Meio-dia: laranja -> branco
		var phase_t = (t - 0.25) / 0.25
		daylight.color = dawn_dusk_color.lerp(day_color, phase_t)
		shadow_alpha = lerp(0.3, 0.0, phase_t) # amanhecendo para totalmente transparente
	elif t < 0.75:
		# Entardecer: branco -> laranja
		var phase_t = (t - 0.5) / 0.25
		daylight.color = day_color.lerp(dawn_dusk_color, phase_t)
		shadow_alpha = lerp(0.0, 0.3, phase_t) # dia para sombra suave
	else:
		# Anoitecer: laranja -> escuro
		var phase_t = (t - 0.75) / 0.25
		daylight.color = dawn_dusk_color.lerp(night_color, phase_t)
		shadow_alpha = lerp(0.3, 1.0, phase_t) # sombra suave -> noite escura

	Shadow.color = Color(0, 0, 0, shadow_alpha)
