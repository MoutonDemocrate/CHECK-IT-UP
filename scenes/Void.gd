extends Node2D

var tween_pos : Tween

func _ready() -> void:
	pass

func _enter() -> void:
	$Slide.position.x = 1600
	#self.show()
	tween_pos = create_tween()
	tween_pos.tween_property($Slide,"position", Vector2(0,0),0.5)
	$Slide/ReferenceRect._tween_alpha(0.0,1.0,0.5)

func _exit() -> void:
	tween_pos = create_tween()
	tween_pos.tween_property($Slide,"position", Vector2(-1700,0),0.5)
	$Slide/ReferenceRect._tween_alpha(1.0,0.0,0.5)
	await tween_pos.finished
	self.hide()
