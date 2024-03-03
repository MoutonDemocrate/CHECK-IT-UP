extends Node2D
class_name Level

@export var difficulty : int = 1
var length : int

@onready var Path : Path2D = $LevelPath2D

func _ready():
	pass

func get_path_final_point_global() -> Vector2 :
	return get_path_point_global(Path.curve.point_count - 1)

func get_path_point_global(i : int) -> Vector2 : 
	return Path.curve.get_point_position(i) + self.position + Vector2(50,-50)

func _hide_path(node : int, progress : float) -> void :
	Path._hide_path(node, progress)

func get_length() -> Array[float] :
	return Path.get_length()
