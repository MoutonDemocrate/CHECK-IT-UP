extends Node

@export var BackgroundCol : Gradient
var game_difficulty : int = 10

func _ready():
	$World._load_next_level()
	
	# Parralax modulation
	var modCol : Color = $Parralax/ColorRect.modulate
	var children_count := $Parralax.get_child_count()
	for i in range(1,children_count):
		$Parralax.get_child(i).modulate = BackgroundCol.sample(float(i-1)/float(children_count))
		
