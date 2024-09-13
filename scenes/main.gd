extends Control

@export var BackgroundCol : Gradient
@export var game_difficulty : int = 0
@export var leeway_level : float = 0
@export var level_number : int = 0

# AS A CUBIC
@export var difficulty_density : float = 5.5
## Describes how easier the game is from base difficulty
@export var easy_patch := 1

var level_got_bigger : bool = false

@onready var world : World = $World
@onready var Music : MusicPlayer = $MusicPlayer
@onready var player : Player = $Player
@onready var background : Background = $Background

func _ready():
	world._load_next_level()

func level_up() -> void :
	level_number += 1
	GlobalData.current_score += 1000
	if level_got_bigger :
		leeway_level += 1
		level_got_bigger = false
		print("LEEWAY LEVEL + 1")
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
	leeway_level*=easy_patch
	print("Runtime : ", runtime,
		"\n - Leeway Level : ", leeway_level,
		"\n - Leeway : ", leeway(leeway_level),
		"\n - Final runtime : ", leeway(leeway_level)+max(runtime,1.0))
	return leeway(leeway_level)+max(runtime,1.0)
	
func init_new_level() -> void :
	var runtime := calculate_runtime()
	var ProgManager : ProgressManager = $Camera2D/ProgressManager
	ProgManager.initialise(runtime)

## Returns the leeway 
func leeway(leeway_l : float) -> float :
	return (4.0*(1.0/((pow(leeway_l,2.0)/pow(difficulty_density,3.0))+1.0)))

func game_over() -> void :
	Music.game_over(10)
	player.game_over()
	background.game_over(1.0)
	world.game_over(2.0)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property($Camera2D/EffectsLayer,"modulate",0.0,1.0)
	await get_tree().create_timer(3).timeout
	$Camera2D/GameOverLayer.activate()
