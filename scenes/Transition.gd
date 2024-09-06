extends Node

func _ready():
	pass

func transition(to_target_scene: String, fade_out := 0.0, fade_in := 0.0) :
	print("SceneTransition...")
	var tween : Tween = create_tween()
	if fade_out != 0.0 :
		print("Modulating out...")
		tween.tween_property(get_tree().root.get_child(get_child_count()-1), "modulate", Color.BLACK, fade_out)
		await tween.finished
	print("Changing scene...")
	var resourceloader := ResourceLoader
	var scene = ResourceLoader.load(to_target_scene)
	get_tree().change_scene_to_packed(scene)
	if fade_in != 0.0 :
		print("Modulating in...")
		get_tree().root.get_child(get_child_count()-1).modulate = Color.BLACK
		tween.tween_property(get_tree().root.get_child(get_child_count()-1), "modulate", Color.WHITE, fade_in)
