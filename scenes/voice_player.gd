extends AudioStreamPlayer

func check_it_up() -> void :
	var old_stream = stream
	stream = preload("res://assets/sounds/sfx/voicelines/check_it_up_fast.ogg")
	play()
	await finished
	stream = old_stream
