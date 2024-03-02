class_name CameraScript
extends Camera2D

var a_inertia : float = 8.0
var a_pos : float = 10.0
var a_zoom : float = 5.0

var follow_player : bool = true
var follow_player_y : bool = false
var zoom_base : float = 1.0

var pos_base : Vector2 = Vector2(800,450)
var inertia : Vector2 = Vector2(0,0)
var shake : Vector2 = Vector2(0,0)

@onready var SpeedLinesRect = $EffectsLayer/SpeedLinesRect
var sl_alpha_tween : Tween

func _ready() -> void :
	_sl_set_inv_speed(50,0.0)
	_sl_appear(0.0)

func set_pos_base(pos : Vector2) -> void :
	pos_base = pos

func _lerp_zoom(zoom_level : float) -> void :
	zoom_base = zoom_level

func _lerp_to_pos(pos : Vector2) :
	print("Camera goes to ", pos)
	pos_base = pos

func _inertia(direction : Vector2, force : int) -> void :
	inertia = direction*force

func _shake() -> void :
	pass

func _physics_process(_delta) -> void :
	zoom = lerp(zoom, Vector2(zoom_base, zoom_base), a_zoom*_delta)
	position = lerp(position, pos_base, a_pos*_delta)
	if follow_player :
		position.x = $"../Player".global_position.x
	if follow_player_y :
		position.y = $"../Player".global_position.y
	$"../Void".global_position = self.global_position
	inertia = lerp(inertia, Vector2.ZERO, a_inertia*_delta)
	position += inertia + shake

func set_sl_alpha(a : float) -> void:
	SpeedLinesRect.material.set_shader_parameter("alpha", a)

func set_sl_inv_speed(s : float) -> void:
	SpeedLinesRect.material.set_shader_parameter("inverse_speed", floor(s))

func _sl_set_angle(direction : Vector2) -> void:
	SpeedLinesRect.material.set_shader_parameter("angle", rad_to_deg(Vector2.RIGHT.angle_to(direction)))

func _sl_dissolve(timespan : float = 0.1):
	sl_alpha_tween = create_tween()
	sl_alpha_tween.tween_method(set_sl_alpha,1.0,0.0,timespan)
	
func _sl_appear(timespan : float = 0.1):
	sl_alpha_tween = create_tween()
	sl_alpha_tween.tween_method(set_sl_alpha,0.0,1.0,timespan)

func _sl_set_inv_speed(new_speed : float,timespan : float = 0.1):
	sl_alpha_tween = create_tween()
	sl_alpha_tween.tween_method(set_sl_inv_speed,SpeedLinesRect.material.get_shader_parameter("inverse_speed"),new_speed,timespan)
