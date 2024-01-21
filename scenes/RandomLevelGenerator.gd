class_name RandomLevelGenerator
extends Node

@export var difficulty : int
var nb_nodes : int
@export var grid_size := Vector2(16,9)

signal finished


func _calculate_random_path() -> Curve2D :
	nb_nodes = difficulty*2
	#print("Calculating random path... n° Nodes : ",nb_nodes)
	
	var pos_array : Array[Vector2]
	
	# print("Added final node : ",Vector2(0,5))
	pos_array.append(Vector2(0,5))
	
	var point1 : Vector2
	var point2 : Vector2
	
	for i in range(0,difficulty) :
		point2 = generate_new_point(grid_size, pos_array[-1])
		# print("Point 2 : ",point2)
		point1 = go_to_from_point(pos_array[-1], point2)
		# print("Point 1 : ",point1)
		
		pos_array.append(point1)
		pos_array.append(point2)
	
	# print("Added final node : (17 ",pos_array[-1].y,")")
	pos_array.append(Vector2(17,pos_array[-1].y))
	
	var curve := Curve2D.new()
	for point in pos_array :
		curve.add_point(Vector2(point.x*100 - 50, point.y*100 + 50))
	
	# print("Path calculated!")
	return curve

func generate_new_point(size : Vector2, last_pos : Vector2) -> Vector2 :
	var rng := RandomNumberGenerator.new()
	var point : Vector2
	while true :
		point = Vector2(
			rng.randi_range(1,size.x-1),
			rng.randi_range(1,size.y-1)
		)
		if point.x != last_pos.x and point.y != last_pos.y :
			return point
	return Vector2(0,0)

func go_to_from_point(start_point : Vector2, end_point : Vector2) -> Vector2 :
	return Vector2(
		end_point.x,
		start_point.y
	)
