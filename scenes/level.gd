extends Node2D

@export var difficulty : int = 1
var length : int

func _ready():
	pass

func get_path_final_point_global() -> Vector2 :
	return get_path_point_global($Path2D.curve.point_count - 1)

func get_path_point_global(i : int) -> Vector2 : 
	return $Path2D.curve.get_point_position(i) + self.position + Vector2(50,-50)

func _hide_path(node : int, progress : float) -> void :
	$Path2D._hide_path(node, progress)
