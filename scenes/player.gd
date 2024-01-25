class_name Player
extends Node2D

## Speed of the player, in blocs per second
@export var speed : float = 10.0

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

enum PlayerState {GOING, GOING_LAST_NODE, CORNER, INTER_RED, INTER_GREEN, INTER_LEAVING, INTER_ENTER}

var state : PlayerState = PlayerState.INTER_GREEN

func _ready():
	last_node.connect($"../World"._load_inter)
	first_node.connect($"../World"._hide_inter)
	stopped_at_inter.connect($"../World"._inter_activities)

func _set_player_green() -> void :
	print("Player is good to go.")
	state = PlayerState.INTER_GREEN
	print(state)

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
				node = 0
				level_nodes_count = $"../World".level.difficulty*2
				print("Node count : ",level_nodes_count)
				print("Emitting signal : leaving_inter")
				$"../Camera2D".follow_player = true
				emit_signal("leaving_inter")
		
		PlayerState.INTER_LEAVING:
			position += direction*speed
			if position.x >= next_node.x :
				state = PlayerState.GOING
				node += 1
				next_node = $"../World".level.get_path_point_global(node)
				$"../Camera2D".follow_player = false
				$"../Camera2D"._lerp_to_pos($"../World".level.global_position + Vector2(800,450))
		
		PlayerState.GOING:
			position += direction*speed
			if (direction.x and (direction.x*position.x >= direction.x*next_node.x)) or (direction.y and (direction.y*position.y >= direction.y*next_node.y)) :
				print("Stopped at : ",next_node, ", node = ",node)
				if node == 1 :
					print("Emitting signal : first_node")
					emit_signal("first_node")
				elif node == level_nodes_count :
					print("Emitting signal : last_node")
					emit_signal("last_node")
				position = next_node
				state = PlayerState.CORNER
				node += 1
				next_node = $"../World".level.get_path_point_global(node)
				direction_to_next_node = calculate_next_node_direction()
				
			line_progress = ((position - $"../World".level.get_path_point_global(node-1)).dot(direction)/(next_node - $"../World".level.get_path_point_global(node-1)).dot(direction))
			if is_nan(line_progress) :
				line_progress = 0.0
			$"../World".level._hide_path(min(node,level_nodes_count), line_progress)
		
		PlayerState.CORNER:
			if direction_to_next_node == Vector2(
				signf(Input.get_action_strength("right") - Input.get_action_strength("left")),
				signf(Input.get_action_strength("down") - Input.get_action_strength("up"))
			) :
				direction = direction_to_next_node
				print("Departing.")
				if node - 1 == level_nodes_count :
					$"../Camera2D".follow_player = true
					$"../Camera2D"._lerp_zoom(1.0)
					state = PlayerState.INTER_ENTER
				else :
					if node == level_nodes_count :
						$"../Camera2D"._lerp_to_pos($"../World".level.get_path_point_global(level_nodes_count))
						$"../Camera2D"._lerp_zoom(1.5)
					state = PlayerState.GOING
					
		
		PlayerState.GOING_LAST_NODE:
			position += direction*speed
			if direction.x*position.x >= direction.x*next_node.x :
				state = PlayerState.INTER_ENTER
				print("Emitting signal : entering_inter")
				emit_signal("entering_inter")
		
		PlayerState.INTER_ENTER:
			position += direction*speed
			if position.x >= ($"../World".inter.position.x + 800) :
				print("Emitting signal : stopped_at_inter")
				emit_signal("stopped_at_inter")
				position.x = $"../World".inter.position.x + 800
				state = PlayerState.INTER_RED

func calculate_next_node_direction() -> Vector2 :
	return (next_node - position).normalized()
