extends CanvasLayer

@export var retry_available : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void :
	for child in get_children():
		if child is ColorRect :
			child.material.set_shader_parameter("ratio",0)
		elif child is Label :
			child.visible_ratio = 0.0

func update_labels() -> void :
	var IdiotLines : TextLines = load("res://assets/text/GameOverLines.tres")
	$Idiot_Label.text = IdiotLines._random_line()
	$Score_Label.text = "YOUR SCORE IS " + str($"../..".level_number) + "."

func activate() -> void :
	update_labels()
	$AnimationPlayer.play("game_over")

func _input(event : InputEvent):
	if retry_available :
		if event.is_action_pressed("down") or event.is_action_pressed("up")or event.is_action_pressed("left"):
			print("PRESSED : NOT RIGHT. QUITTING...")
			retry_available = false
			get_tree().quit()
		if event.is_action_pressed("right"):
			print("PRESSED : RIGHT. RETRYING.")
			retry_available = false
			Transition.transition("res://scenes/Controls.tscn",1.0,0.0)
