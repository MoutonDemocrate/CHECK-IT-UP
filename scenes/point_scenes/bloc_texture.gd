class_name TextureBloc
extends TextureRect

@export var progress : float = 0.0
var prog_f : float = 1.0
var goodbye_progress := 0.0
var pos_base : Vector2
var min_f : float

var is_tweened : bool = false

func set_goodbye_progress(f : float) -> void :
	print(f)
	goodbye_progress = f
	position = pos_base + Vector2(0, 75)*f
	min_f = minf(min_f, f)
	self_modulate = Color(1.0,1.0,1.0,(1.0-min_f))

@export var is_corner : bool = false
@export var flip : bool = false

func _ready() -> void :
	print("New bloc created")
	
func _update(new_prog : float = 1.0) -> void:
	if is_corner :
		texture = load("res://assets/textures/paths/corner_basic.png")
	else :
		texture = load("res://assets/textures/paths/line_basic.png")


func _goodbye() -> void :
	if not pos_base :
		pos_base = position
	var tween : Tween
	tween = create_tween()
	
	tween.tween_method(set_goodbye_progress,0.0,1.0,0.1)
	
