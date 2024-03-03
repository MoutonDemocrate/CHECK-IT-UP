extends Node

@export var BackgroundCol : Gradient
@export var game_difficulty : int = 0
@export var leeway_level : int = 0
@export var level_number : int = 0

@export_range(0.8,2.5) var difficulty_density : float = 1.2

var level_got_bigger : bool = false

@onready var world : World = $World
@onready var Music : MusicPlayer = $MusicPlayer
@onready var player : Player = $Player
@onready var background : Background = $Background

func _ready():
	world._load_next_level()

func level_up() -> void :
	level_number += 1
	if level_got_bigger :
		leeway_level += 1
		level_got_bigger = false
		print("LEEWAY DIMINISHED")
	else :
		level_got_bigger = true
		game_difficulty += 1
		print("GAME DIFFICULTY + 1")

func calculate_runtime() -> float :
	var runtime : float = 0.0
	var length : Array[float] = world.level.get_length()
	var base_speed : float = $Player.base_speed
	var speed_bonus : float = $Player.speed_bonus
	for i in range(0, game_difficulty*2 - 1) :
		runtime += length[i] / (base_speed + speed_bonus*(i+1))
	print("Runtime : ", runtime,
		" - Leeway Level : ", leeway_level,
		" - Leeway factor : ", f(leeway_level, 1),
		" - Final runtime : ", f(leeway_level, runtime))
	return f(leeway_level, runtime)
	
func init_new_level() -> void :
	var runtime := calculate_runtime()
	var ProgManager : ProgressManager = $Camera2D/ProgressManager
	ProgManager.initialise(runtime)

## Returns the leeway 
func f(leeway : float, runtime : float) -> float :
	return  (1 + 4*(1/((leeway/difficulty_density)+1)))*max(runtime,1.0)

func game_over() -> void :
	Music.game_over()
	player.game_over()
	background.game_over()
	await get_tree().create_timer(0.5).timeout
	$Camera2D/GameOverLayer.activate()
