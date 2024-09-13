extends Control
class_name MainNode

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
@onready var void_node : VoidNode = $Void
@onready var credits : Node2D = $Credits
@onready var camera : CameraScript = $Camera2D

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

var credits_on : bool = false
func _input(event: InputEvent) -> void:
	if level_number == 1 and player.state in [player.PlayerState.INTER_GREEN,player.PlayerState.INTER_RED] :
		if not credits_on and event.is_action_pressed("down") :
			credits_on = true
			void_node.speedlines.hide()
			var tween := create_tween()
			tween.set_parallel(true)
			tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
			tween.tween_property(void_node.ui, "modulate",Color.TRANSPARENT,0.05)
			tween.tween_property(camera, "pos_base", Vector2(800,450) + Vector2(0,900), 0.2)
			await tween.finished
			void_node.follow_camera = false
			
		elif credits_on and event.is_action_pressed("up") :
			credits_on = false
			void_node.speedlines.show()
			void_node.follow_camera = true
			var tween := create_tween()
			tween.set_parallel(true)
			tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
			tween.tween_property(void_node.ui, "modulate",Color.WHITE,0.5)
			tween.tween_property(camera, "pos_base", Vector2(800,450), 0.5)
			await tween.finished
			void_node.follow_camera = false
			void_node.speedlines.show()
