extends Control

@onready var AnimPlayer : AnimationPlayer = $AnimationPlayerGlobal
@onready var LevelEndLabel : Label = $LevelEnd_Label

func _ready() -> void:
	LevelEndLabel.hide()
	AnimPlayer.play("game_begin")
	AnimPlayer.queue("press_right_loop")

func inter_anim() -> void :
	AnimPlayer.clear_queue()
	AnimPlayer.stop()
	AnimPlayer.play("level_end")
	AnimPlayer.queue("press_right_loop")
