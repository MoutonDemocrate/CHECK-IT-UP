extends AudioStreamPlayer
class_name MusicPlayer

var tween : Tween
var game_still_running := true

func _ready() -> void :
	play()

func game_over(duration : float = 2.0):
	game_still_running = false
	tween = create_tween()
	tween.tween_property(self,"pitch_scale", 0.001, duration)
	await tween.finished
	stop()
