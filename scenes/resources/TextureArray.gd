extends Resource
class_name TextureArray

@export var textures : Array[Texture2D] = []

func get_random_texture() -> Texture2D :
	return textures[randi_range(0,textures.size()-1)]
