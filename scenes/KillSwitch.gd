extends Node

func _input(event: InputEvent) -> void:
	if event.is_action("kill"):
		get_tree().quit()
