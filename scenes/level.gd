extends Node2D

@export var difficulty : int = 1

func _ready():
	null

func get_path_final_point_global() -> Vector2 :
	return get_path_point_global($Path2D.curve.point_count - 1)

func get_path_point_global(i : int) -> Vector2 : 
	return $Path2D.curve.get_point_position(i) + self.position + Vector2(50,-50)
