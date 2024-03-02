extends Node

@export var BackgroundCol : Gradient
var game_difficulty : int = 1

func _ready():
	$World._load_next_level()
