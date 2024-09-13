extends Node2D
class_name Background

@onready var camera_pivot : Node3D = $ColorRect/SubViewport/CameraPivot
@onready var terrain : Node3D = $ColorRect/SubViewport/terrain

@onready var cube_pivot : Node3D = $ColorRect/SubViewport/CameraPivot/cube/Cube

var camera_pos : Vector3 = Vector3.ZERO
var a_camera : float = 10.0

var time : float = 0.0
var a_cube : float = 4.0
var cube_angular_velocity : Vector3 = Vector3.ZERO
var idle_angular_velocity : Vector3


func _next_terrain() -> void :
	var terrain_list = terrain.get_children()
	terrain_list.pop_front()
	for index in range(0,len(terrain_list)) :
		if terrain_list[index].visible :
			print("Old terrain : ", terrain_list[index].name)
			terrain_list[index].hide()
			if index == len(terrain_list) - 1 :
				print("New terrain : ", terrain_list[0].name)
				terrain_list[0].show()
				break
			else :
				print("New terrain : ", terrain_list[index+1].name)
				terrain_list[index+1].show()
				break

func _ready() -> void :
	var mat = ShaderMaterial.new()
	for node in $ColorRect/SubViewport/terrain.get_children() :
		mat.shader = load("res://assets/models/terrain.gdshader")
		node.material_override = mat.duplicate()
		
	_next_terrain()
	$ColorRect/SubViewport/CameraPivot/Camera3D.global_position = Vector3(0,4,0) + camera_pos

func set_camera_pos(pos : Vector3) -> void :
	camera_pos = pos

func _physics_process(delta) -> void :
	terrain.rotation.y += 0.002
	camera_pivot.rotation.x = lerpf(camera_pivot.rotation.x, camera_pos.z, a_camera * delta)
	camera_pivot.rotation.z = lerpf(camera_pivot.rotation.z, camera_pos.x, a_camera * delta)
	
	time += delta
	
	idle_angular_velocity = Vector3(
		cos(time),
		cos(time + 2*PI/3),
		cos(time + 4*PI/3)
	)
	
	cube_angular_velocity = lerp(cube_angular_velocity, idle_angular_velocity, a_cube * delta)
	
	cube_pivot.rotate_object_local(Vector3(1,0,0), cube_angular_velocity.x*delta)
	cube_pivot.rotate_object_local(Vector3(0,1,0), cube_angular_velocity.y*delta)
	cube_pivot.rotate_object_local(Vector3(0,0,1), cube_angular_velocity.z*delta)
	
#	camera_pos = lerp(
#		camera_pos,
#		Vector3.ZERO,
#		a_camera * delta
#	)

func game_over(duration:float = 1.0) -> void :
	var tween := create_tween()
	tween.tween_property(self,"modulate",Color(0.0,0.0,0.0,0.0),duration)

func cube_impulse(axis_vector : Vector3, force : float) -> void:
	cube_angular_velocity = axis_vector.normalized()*force
