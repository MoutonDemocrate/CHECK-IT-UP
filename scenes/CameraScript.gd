class_name CameraScript
extends Camera2D

var a_inertia : float = 8.0
var a_pos : float = 10.0
var a_zoom : float = 5.0

var follow_player : bool = true
var zoom_base : float = 1.0

var pos_base : Vector2 = Vector2(800,450)
var inertia : Vector2 = Vector2(0,0)
var shake : Vector2 = Vector2(0,0)

func _ready() -> void :
	pass

func set_pos_base(pos : Vector2) -> void :
	pos_base = pos

func _lerp_zoom(zoom_level : float) -> void :
	zoom_base = zoom_level

func _lerp_to_pos(pos : Vector2) :
	pos_base = pos

func _inertia(direction : Vector2, force : int) -> void :
	inertia = direction*force

func _shake() -> void :
	pass

func _physics_process(_delta) -> void :
	zoom = lerp(zoom, Vector2(zoom_base, zoom_base), a_zoom*_delta)
	position = lerp(position, pos_base, a_pos*_delta)
	if follow_player :
		position = $"../Player".global_position
	position += inertia + shake
	inertia = lerp(inertia, Vector2.ZERO, a_inertia*_delta)
