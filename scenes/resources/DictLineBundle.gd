extends LineBundle
class_name DictLineBundle

## Lines of text
@export var line_dict : Dictionary = {
	"default" : []
}

func random_line(args : Array = []) -> String :
	var keys : Array[String] = ["default"]
	
	for arg in args :
		if arg in line_dict.keys() :
			keys.append(arg)
	
	var key : String = keys[randi_range( 0 , keys.size()-1 )]
	
	return line_dict[key][randi_range( 0 , line_dict[key].size()-1 )]
