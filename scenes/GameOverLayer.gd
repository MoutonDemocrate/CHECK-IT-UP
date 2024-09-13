extends CanvasLayer

@export var retry_available : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void :
	for child in get_children():
		if child.name == "BlackScreen" :
			child.material.set_shader_parameter("ratio",0)
		elif child is Label :
			child.visible_ratio = 0.0

func update_labels() -> void :
	var idiotlines : VoiceLines = load("res://assets/text/GameOverVoicelines.tres")
	var line : VoiceLine = idiotlines.random_line()
	$Idiot_Label.text = line.text
	%IdiotPlayer.stream = line.voice
	$Score_Label.text = "YOUR SCORE IS " + str(GlobalData.current_score) + "."

func activate() -> void :
	update_labels()
	$AnimationPlayer.play("game_over")

func to_the_score_board() -> void :
	Transition.transition("res://scenes/score_enter.tscn",0.5,0.0)

func _input(event : InputEvent) -> void :
	if retry_available :
		if event.is_action_pressed("left") :
			KillSwitch.kill()
		elif event.is_action_pressed("right") :
			to_the_score_board()
		elif event.is_action_pressed("up") :
			GlobalData.going_to_scoreboard = true
			to_the_score_board()
		elif event.is_action_pressed("down") :
			Transition.transition("res://scenes/Controls.tscn",0.5,0.0)
