extends Node

func _ready():
	pass

func transition(to_target_scene: String, fade_out := 0.0, fade_in := 0.0) -> Error:
	print("SceneTransition...")
	ResourceLoader.load_threaded_request(to_target_scene)
	var tween : Tween = create_tween()
	if fade_out != 0.0 :
		print("Modulating out...")
		tween.tween_property(get_tree().root.get_child(get_child_count()-1), "modulate", Color.BLACK, fade_out)
		await tween.finished
	print("Waiting for scene to load...")
	var progress := []
	var status : ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(to_target_scene,progress) 
	while status != ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		await get_tree().create_timer(0.2).timeout
		status = ResourceLoader.load_threaded_get_status(to_target_scene,progress)
		match status :
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED :
				push_error("Thread load failed !")
				return ERR_CANT_ACQUIRE_RESOURCE
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE :
				push_error("Invalid resource !")
				return ERR_CANT_ACQUIRE_RESOURCE
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
				pass
	print("Changing scene...")
	var scene : PackedScene = ResourceLoader.load_threaded_get(to_target_scene)
	get_tree().change_scene_to_packed(scene)
	if fade_in != 0.0 :
		print("Modulating in...")
		get_tree().root.get_child(get_child_count()-1).modulate = Color.BLACK
		tween.tween_property(get_tree().root.get_child(get_child_count()-1), "modulate", Color.WHITE, fade_in)
	return OK
