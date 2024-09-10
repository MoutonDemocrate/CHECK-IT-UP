extends LineBundle
class_name VoiceLines

@export var voicelines : Array[VoiceLine] = []

func random_line(args : Array = []) -> VoiceLine :
	return voicelines.pick_random()
