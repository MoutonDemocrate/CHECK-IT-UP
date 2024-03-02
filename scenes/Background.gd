extends Node2D

@onready var camera_pivot : Node3D = $ColorRect/SubViewport/CameraPivot
@onready var terrain : Node3D = $ColorRect/SubViewport/terrain

var camera_pos : Vector3 = Vector3.ZERO
var a_camera : float = 10.0

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
	
#	camera_pos = lerp(
#		camera_pos,
#		Vector3.ZERO,
#		a_camera * delta
#	)
