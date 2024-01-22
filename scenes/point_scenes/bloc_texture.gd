@tool
extends Node2D

@export var texture_bloc : Texture2D
@onready var textureRect : TextureRect = $TextureRect

@export var progress : float = 0.0
var prog_f : float = 1.0

@export var is_corner : bool = false
@export var flip : bool = false

func _ready() -> void :
	textureRect.texture = texture_bloc 
	textureRect.material = ShaderMaterial.new()
	textureRect.material.shader = load("res://assets/shaders/line_fade.gdshader")
	_set_progress(progress)

func _set_progress(new_prog : float) -> void :
	progress = new_prog
	textureRect.material.set_shader_parameter("progress", progress)
	textureRect.material.set_shader_parameter("flip", -1)
	if flip :
		prog_f = 1.0 - progress
		textureRect.material.set_shader_parameter("progress", prog_f)
		textureRect.material.set_shader_parameter("flip", -1)
	
func _physics_process(_delta):
	_set_progress(progress)
