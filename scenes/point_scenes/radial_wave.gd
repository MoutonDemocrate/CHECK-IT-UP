@tool
extends Effect
class_name RadialWave

var activated : bool = false
var expanse_speed : float = 0.3
@onready var rect : ColorRect = ColorRect.new()

func _ready():
	self.process_mode = PROCESS_MODE_DISABLED
	rect.size = Vector2(2,2) * 10000
	rect.size = (-1) * Vector2(1,1) * 10000
	var wave_shader : ShaderMaterial = ShaderMaterial.new()
	wave_shader.shader = load("res://scenes/point_scenes/radial_wave.gdshader")
	rect.material = wave_shader
	rect.material.set_shader_parameter("radius", 0.0)
	add_child(rect)

func activate(params : Array = []) -> void :
	rect.material.set_shader_parameter("center", params[0])
	if len(params) >= 2 :
		expanse_speed = params[1]
	
	activated = true
	self.process_mode = PROCESS_MODE_ALWAYS

func _process(delta):
	if activated :
		rect.material.set_shader_parameter("radius", rect.material.get_shader_parameter("radius") + expanse_speed * delta)
		if rect.material.get_shader_parameter("radius") >= 0.05 :
			queue_free()
