extends Control

@onready var AnimPlayer : AnimationPlayer = $AnimationPlayerGlobal
@onready var LevelEndLabel : Label = $LevelEnd_Label

@onready var voiceline_player : AudioStreamPlayer = %VoicePlayer

@onready var player : Player  = $"../../../Player"

func _ready() -> void:
	LevelEndLabel.hide()
	AnimPlayer.play("game_begin")
	AnimPlayer.queue("press_right_loop")

func inter_anim() -> void :
	AnimPlayer.clear_queue()
	AnimPlayer.stop()
	AnimPlayer.play("level_end")
	await get_tree().create_timer(0.4).timeout
	voiceline_player.play()
	await voiceline_player.finished
	player._set_player_green()
	AnimPlayer.play("press_right_loop")
