class_name Player
extends Node2D

## Base speed of the player
@export var base_speed : float = 3000.0
## Speed bonus gained per combo level
@export var speed_bonus : float = 100.0

@export_range(0,10) var combo : int = 0
@export_range(0.0,0.5) var combo_window : float = 0.1

signal leaving_inter
signal first_node
signal last_node
signal entering_inter
signal stopped_at_inter

var line_progress : float

var direction : Vector2

var level_nodes_count : int
var node : int
var next_node : Vector2
var direction_to_next_node : Vector2

enum PlayerState {GOING, GOING_LAST_NODE, CORNER, INTER_RED, INTER_GREEN, INTER_LEAVING, INTER_ENTER, DEAD}

@export var state : PlayerState = PlayerState.INTER_RED

var corner_timer : float = 0.0

@onready var speed := base_speed

func _ready():
	first_node.connect($"../World"._hide_inter)
	first_node.connect($"../Camera2D/ProgressManager".start)
	last_node.connect($"../World"._load_inter)
	last_node.connect($"../Camera2D/ProgressManager".stop)
	stopped_at_inter.connect($"../World"._inter_activities)

func change_spark_speed(velocity : float = 1500, spread : float = 500, angle : float = 25) -> void :
	$GPUParticles2D.process_material.initial_velocity_min = velocity - spread
	$GPUParticles2D.process_material.initial_velocity_max = velocity + spread
	
	print($GPUParticles2D.process_material.initial_velocity_min, ", ", $GPUParticles2D.process_material.initial_velocity_max)

func _set_player_green() -> void :
	print("Player is good to go.")
	state = PlayerState.INTER_GREEN

func _physics_process(_delta):
	
	match state :
		PlayerState.INTER_RED:
			pass
		
		PlayerState.INTER_GREEN:
			if Input.get_action_strength("right") - Input.get_action_strength("left") > 0 :
				state = PlayerState.INTER_LEAVING
				node = 0
				direction = Vector2.RIGHT
				print("Leaving inter ---->")
				next_node = $"../World".level.get_path_point_global(0)
				print("Next node : ", next_node)
				node = 0
				level_nodes_count = $"../World".level.difficulty*2
				print("Node count : ",level_nodes_count)
				print("Emitting signal : leaving_inter")
				$"../Camera2D".follow_player = true
				emit_signal("leaving_inter")
				$"../Camera2D"._sl_appear(0.5)
				$"../Void"._exit()
		
		PlayerState.INTER_LEAVING:
			position += direction*speed*_delta
			if position.x >= next_node.x :
				state = PlayerState.GOING
				node += 1
				next_node = $"../World".level.get_path_point_global(node)
				$"../Camera2D".follow_player = false
				$"../Camera2D"._lerp_to_pos($"../World".level.global_position + Vector2(800,450))
				$"../Background".position = $"../World".level.global_position
				
		PlayerState.GOING:
			position += direction*speed*_delta
			$"../Camera2D"._inertia(direction,-10)
			if (direction.x and (direction.x*position.x >= direction.x*next_node.x)) or (direction.y and (direction.y*position.y >= direction.y*next_node.y)) :
				$"../Camera2D"._sl_dissolve()
				print("Stopped at : ",next_node, ", node = ",node)
				if node == 1 :
					print("Emitting signal : first_node")
					emit_signal("first_node")
				elif node == level_nodes_count :
					print("Emitting signal : last_node")
					emit_signal("last_node")
				position = next_node
				var Bonk : Effect = preload("res://scenes/point_scenes/bonk.tscn").instantiate()
				$"../World".add_child(Bonk)
				Bonk.global_position = self.global_position
				Bonk.activate([direction])
				state = PlayerState.CORNER
				node += 1
				next_node = $"../World".level.get_path_point_global(node)
				direction_to_next_node = calculate_next_node_direction()
				$"../Camera2D"._inertia(direction,20)
				$"../Camera2D"._shake()
				$"../Background".set_camera_pos(Vector3(direction.x,0,direction.y)*0.6)
				$GPUParticles2D.emitting = false
				
			line_progress = ((position - $"../World".level.get_path_point_global(node-1)).dot(direction)/(next_node - $"../World".level.get_path_point_global(node-1)).dot(direction))
			if is_nan(line_progress) :
				line_progress = 0.0
			$"../World".level._hide_path(min(node,level_nodes_count), line_progress)
		
		PlayerState.CORNER:
			corner_timer += _delta
			if (corner_timer > combo_window) and (combo > 0) :
				reset_combo()
				
			if direction_to_next_node == Vector2(
				signf(Input.get_action_strength("right") - Input.get_action_strength("left")),
				signf(Input.get_action_strength("down") - Input.get_action_strength("up"))
			) :
				direction = direction_to_next_node
				look_at(position + direction)
				print("Departing. Corner timer is ", corner_timer)
				$GPUParticles2D.emitting = true
				$"../Camera2D"._sl_set_angle(direction)
				$"../Camera2D"._sl_appear()
				
				if corner_timer <= combo_window :
					add_combo()
				
				corner_timer = 0.0
				
				if node - 1 == level_nodes_count :
					$"../Camera2D".follow_player = true
					$"../Camera2D"._lerp_zoom(1.0)
					reset_combo(true)
					state = PlayerState.INTER_ENTER
					$"../Void"._enter()
					print("Void entered!")
				else :
					if node == level_nodes_count :
						$"../Camera2D"._lerp_to_pos($"../World".level.get_path_point_global(level_nodes_count))
						$"../Camera2D"._lerp_zoom(1.5)
					state = PlayerState.GOING
		
		PlayerState.GOING_LAST_NODE:
			position += direction*speed*_delta
			if direction.x*position.x >= direction.x*next_node.x :
				state = PlayerState.INTER_ENTER
				print("Emitting signal : entering_inter")
				emit_signal("entering_inter")
				
		
		PlayerState.INTER_ENTER:
			position += direction*speed*_delta
			if position.x >= ($"../World".inter.position.x + 800) :
				print("Emitting signal : stopped_at_inter")
				emit_signal("stopped_at_inter")
				position.x = $"../World".inter.position.x + 800
				state = PlayerState.INTER_RED
				$"../Camera2D"._sl_dissolve(0.5)
				$"../Camera2D".follow_player = false
				$"../Camera2D".position = position
				$"../Camera2D"._lerp_to_pos($"../World".inter.global_position + Vector2(800,-300))
				$"../Void/Slide/UI".inter_anim()
		
		PlayerState.DEAD:
			pass
		
func calculate_next_node_direction() -> Vector2 :
	return (next_node - position).normalized()

func _input(event : InputEvent):
	if event.is_action_pressed("m1"):
		var radial_wave : RadialWave = RadialWave.new()
		var center : Vector2 = (self.global_position + self.get_canvas_transform().origin) / get_viewport().get_visible_rect().size
		radial_wave.position += self.global_position
		get_parent().add_child(radial_wave)
		radial_wave.activate([center])

func add_combo() -> void:
	combo += 1
	speed += speed_bonus
	print("COMBO INCREASED ! (",combo,")")

func reset_combo(natural := false) -> void:
	combo = 0
	speed = base_speed
	if natural :
		print("NATURAL COMBO LOSS.")
	else :
		print("COMBO LOST ! RESET.")

func game_over() -> void:
	state = PlayerState.DEAD
	$"../Camera2D"._sl_dissolve(0.001)
	$GPUParticles2D.emitting = false
	$DeathParticles.emitting = true
