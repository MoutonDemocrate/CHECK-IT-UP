extends Node2D
class_name VoidNode

@onready var main : MainNode = $".."
@onready var ui : Control = $Slide/UI
@onready var speedlines : Control = $Slide/ReferenceRect

@onready var sfxplayer : SFXPlayer = %SFXplayer

var tween_pos : Tween

var follow_camera : bool = false

func _ready() -> void:
	pass

func _enter() -> void:
	sfxplayer.play_vol_pan(sfxplayer.SFX_SLIDE_IN,0.0,0.0)
	$Slide.position.x = 1600
	var arg : String = ""
	if !$"..".level_got_bigger :
		arg = "bigger"
	else :
		arg = "faster"
	$Slide/UI/MotivationLabel_Label.randomise_text([arg])
	$Slide/UI/LevelEnd_Label.randomise_text()
	print("RANDOMISING TEXT (with arg = ",arg,")")
	self.show()
	tween_pos = create_tween()
	tween_pos.tween_property($Slide,"position", Vector2(0,0),0.5)
	$Slide/ReferenceRect._tween_alpha(0.0,1.0,0.5)

func _exit() -> void:
	sfxplayer.play_vol_pan(sfxplayer.SFX_SLIDE_OUT,0.0,0.0)
	tween_pos = create_tween()
	tween_pos.tween_property($Slide,"position", Vector2(-1700,0),0.5)
	$Slide/ReferenceRect._tween_alpha(1.0,0.0,0.5)
	await tween_pos.finished
	$Slide/UI/CHECK_IT_UP.hide()
	$Slide/UI/MotivationLabel_Label.hide()
	$Slide/UI/LevelEnd_Label.hide()
	$Slide/UI/PressRight_Label.hide()
	$Slide/UI/CHECKMARK.hide()
	self.hide()
	
func _process(delta: float) -> void:
	if follow_camera :
		position = main.camera.position
