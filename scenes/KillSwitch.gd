extends Node

#const kill_sfx : AudioStream = preload()

func _input(event: InputEvent) -> void:
	if event.is_action("kill"):
		kill()
		
func kill(instant : bool = false) -> void :
	print("SOMEONE WANTS ME DEAD...")
	#var player := AudioStreamPlayer.new()
	#add_child(player)
	#player.stream = kill_sfx
	#player.bus = &"SFX"
	#player.play()
	#await get_tree().create_timer(0.0).timeout
	print("AAAARGHHH IM DYING")
	get_tree().quit()
