extends LineBundle
class_name SimpleLineBundle

## Lines of text
@export var lines : Array[String] = []

func random_line(_args : Array = []) -> String :
	return lines.pick_random()
