extends AudioStreamPlayer
class_name SFXPlayer

@export var SFX_CORNER : Array[AudioStream] = [null]
@export var SFX_CHECK_1 : AudioStream = null
@export var SFX_CHECK_2 : AudioStream = null
@export var SFX_SLIDE_IN : AudioStream = null
@export var SFX_SLIDE_OUT : AudioStream = null

func play_vol_pan(sfx : AudioStream, vol : float = 0.0, pan : float = 0.0) -> void:
	volume_db = vol
	(AudioServer.get_bus_effect(4,0) as AudioEffectPanner).pan = clampf(pan,-1.0,1.0)
	stream = sfx
	play()
