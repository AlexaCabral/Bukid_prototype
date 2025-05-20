class_name DayNightComponent
extends CanvasModulate

@export var day_night_gradient_texture: GradientTexture1D

func _ready() -> void:
	DayNightManager.game_time.connect(on_game_time)
	
func on_game_time(time: float) -> void:
	var sample_value = 0.5 * (sin(time - PI * 0.5) + 1.0)
	color = day_night_gradient_texture.gradient.sample(sample_value)
