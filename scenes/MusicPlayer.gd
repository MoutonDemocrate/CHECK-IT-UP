extends AudioStreamPlayer
class_name MusicPlayer

var tween : Tween
var game_still_running := true

func _ready() -> void :
	restart()

# This shit plays music.
func restart() -> void :
	game_still_running = true
	stream = load("res://assets/sounds/music/KICK_CHECK_final_-001.wav")
	play()
	

func _on_finished():
	if game_still_running :
		stream = load("res://assets/sounds/music/KICK_CHECK_final_-002.wav")
		play()

func game_over(duration : float = 2.0):
	game_still_running = false
	tween = create_tween()
	tween.tween_property(self,"pitch_scale", 0.0, 2.0)
	await tween.finished
	stop()
