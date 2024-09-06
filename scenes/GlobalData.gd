extends Node

@export var current_score : int = 0
@export var going_to_scoreboard : bool = false

func get_object_properties(obj : Object) -> Array[String] :
	var list : Array[String] = []
	for each in obj.get_property_list() :
		list.append(each["name"])
	return list
