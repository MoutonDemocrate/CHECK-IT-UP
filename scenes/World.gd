extends Node2D

var old_inter : Node2D
var inter : Node2D
var level : Node2D

@onready var player : Player = $"../Player"

var levelNode : PackedScene = preload("res://scenes/level.tscn")
var interNode : PackedScene = preload("res://scenes/inter.tscn")

func _ready() -> void :
	inter = $inter

func _load_inter() -> void :
	# Adding next interlevel
	old_inter = inter
	inter = interNode.instantiate()
	inter.position = level.get_path_final_point_global() - Vector2(50,0)
	add_child(inter)
	print("Inter loaded!")

func _hide_inter() -> void: 
	inter.hide()

func _load_next_level() -> void:
	
	# Adding next level
	level = levelNode.instantiate()
	print("Instantiated level.")
	level.difficulty = $"..".game_difficulty
	print("Set difficulty to ", $"..".game_difficulty)
	level.position = inter.position + Vector2(1650, -500)
	add_child(level)
	print("Added level to tree.")
	$"..".game_difficulty += 1

func _inter_activities():
	inter.position = Vector2(0,750)
	player.position = Vector2(800,750)
	old_inter.queue_free()
	level.queue_free()
	_load_next_level()
	await get_tree().create_timer(1.0).timeout
	$"../Background"._next_terrain()
	player._set_player_green()
