extends Resource
class_name TextLines

## Lines of text
@export var text_lines : Dictionary = {
	"default" : []
}

func _random_line(args : Array = []) -> String :
	var keys : Array[String] = ["default"]
	
	for arg in args :
		if arg in text_lines.keys() :
			keys.append(arg)
	
	var key : String = keys[randi_range( 0 , keys.size()-1 )]
	
	return text_lines[key][randi_range( 0 , text_lines[key].size()-1 )]
