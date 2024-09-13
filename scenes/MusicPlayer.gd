extends AudioStreamPlayer
class_name MusicPlayer

var tween : Tween
var game_still_running := true

func _ready() -> void :
	AudioServer.set_bus_effect_enabled(1,1,false)
	play()

func game_over(duration : float = 2.0):
	game_still_running = false
	
	tween = create_tween()
	tween.set_parallel(true)
	AudioServer.set_bus_effect_enabled(1,1,true)
	tween.tween_property((AudioServer.get_bus_effect(1,1) as AudioEffectPitchShift),"pitch_scale",0.001,duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	#tween.tween_property(self,"volume_db", -30, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	stop()
