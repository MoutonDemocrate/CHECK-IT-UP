extends LineBundle
class_name ArrayLineBundle

## Lines of text
@export var lines : Array = []

func random_line(args : Array = []) -> String :
	return lines.pick_random()
