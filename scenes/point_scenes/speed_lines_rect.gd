class_name SpeedLinesRect
extends ColorRect

var tween : Tween

func _ready():
	pass

func _set_color_a(col : Color = Color(0.0,0.65,0.69)) -> void :
	material.set_shader_parameter("line_color_a", col)

func _set_color_b(col : Color = Color(1.0,1.0,1.0)) -> void :
	material.set_shader_parameter("line_color_a", col)

func _set_threshold(thres : float = 0.75) -> void :
	material.set_shader_parameter("line_threshold", thres)

func _set_inv_speed(inv_speed : float = 10) -> void :
	material.set_shader_parameter("inverse_speed", inv_speed)

func _set_line_length(length : float = 1000) -> void :
	material.set_shader_parameter("line_length", length)

func _set_angle(angle : float = 0) -> void :
	material.set_shader_parameter("angle", angle)

func _set_alpha(alpha : float = 1) -> void :
	material.set_shader_parameter("alpha", alpha)

func _set_parameter(param : String, value) -> void :
	material.set_shader_parameter(param, value)

func _tween_parameter(param : String, start, end, duration : float = 0.5) -> void :
	tween = create_tween()
	print("Tween parameter called with param : ",param,", start = ",start,", end = ",end)
	tween.tween_method(_set_parameter.bind(param),start, end, duration)
