extends Node

var game_difficulty : int = 3

func _ready():
	$World._load_next_level()
