extends Control

@onready var Tabs : TabContainer = $TabContainer

## Onreadys for the name selection
@onready var HBoxName : HBoxContainer = $TabContainer/VBoxContainer/VBoxContainer/HBoxName
@onready var SelectPanel : PanelContainer = $TabContainer/VBoxContainer/VBoxContainer/HBoxSelect/SelectPanel
@onready var SelectLabel : Label = SelectPanel.get_child(0)

## Onreadys for the score print
@onready var Scroller : ScrollContainer = $TabContainer/VBoxScoreboard/MarginContainer/ScrollContainer
@onready var VBoxScores : VBoxContainer = $TabContainer/VBoxScoreboard/MarginContainer/ScrollContainer/HBoxContainer/VBoxScores

var char_list : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ☑"
var select_index : int = 0

var playerName : String = ""

func _ready() -> void:
	Tabs.current_tab = 0
	SelectLabel.text = char_list[select_index]
	if not FileAccess.file_exists("user://scoreboard.tres") :
		var scoreboard = ScoreBoard.new()
		var score = Score.new()
		score.score = 44000
		score.player_name = "MoutonDMCR"
		score.date = ""
		scoreboard.add_score(score)
		ResourceSaver.save(scoreboard, "user://scoreboard.tres")
	else :
		var scoreboard : ScoreBoard = load("user://scoreboard.tres")
		if scoreboard.version == "1" :
			update_scoreboard_version("user://scoreboard.tres", "2")
	
	if GlobalData.going_to_scoreboard :
		GlobalData.going_to_scoreboard = false
		fill_scores()
		Tabs.current_tab = 2
	
func _input(event : InputEvent):
	if Tabs.current_tab == 0 :
		input_name_enter(event)
	elif Tabs.current_tab == 2 :
		input_score_board(event)

func input_name_enter(event : InputEvent) -> void :
	if event.get_action_strength("up") >= 0.9 :
		if char_list[select_index] == "☑":
			name_entered()
			return
		playerName += char_list[select_index]
		if playerName.length() >= 11 :
			playerName[10] = ''
		update_name()
	
	if event.get_action_strength("down") >= 0.9 :
		if playerName != "":
			playerName = playerName.left(playerName.length()-1)
		update_name()
	
	if event.is_action_pressed("left") or event.is_action_pressed("right") :
		if event.get_action_strength("left") >= 0.9 :
			select_index = (select_index - 1) % char_list.length()
		if event.get_action_strength("right") >= 0.9 :
			select_index = (select_index + 1) % char_list.length()
		SelectLabel.text = char_list[select_index]

func update_name() -> void :
	print("Name is \"",playerName,"\".")
	for i in range(0,playerName.length()) :
		HBoxName.get_child(i).get_child(0).text = playerName[i]
	for i in range(playerName.length(), 9) :
		HBoxName.get_child(i).get_child(0).text = ""

func name_entered() -> void :
	Tabs.current_tab += 1
	var scoreboard : ScoreBoard = load("user://scoreboard.tres")
	var score : Score = Score.new()
	score.player_name = playerName
	score.score = GlobalData.current_score
	scoreboard.add_score(score)
	ResourceSaver.save(scoreboard, "user://scoreboard.tres")
	await get_tree().create_timer(0.2).timeout
	fill_scores()
	Tabs.current_tab += 1

func fill_scores() -> void:
	var scoreboard : ScoreBoard = load("user://scoreboard.tres")
	var ScoreLabel : ScoreItem
	var score : Score
	for i in range(0,len(scoreboard.scores)) :
		score = scoreboard.scores[i]
		ScoreLabel = load("res://scenes/point_scenes/score.tscn").instantiate()
		ScoreLabel.rank = i + 1
		ScoreLabel.playerName = score.player_name
		ScoreLabel.score = score.score
		ScoreLabel.date = score.date
		VBoxScores.add_child(ScoreLabel)
		ScoreLabel.update()

func input_score_board(event : InputEvent) -> void :
	if event.get_action_strength("right") >= 0.9 :
		print("PRESSED RIGHT ! ANOTHER ROUND IT IS.")
		Transition.transition("res://scenes/Controls.tscn",1.0,0.0)
	elif event.get_action_strength("left") >= 0.9 :
		print("DIDN'T PRESS RIGHT : DIE.")
		get_tree().quit()
	elif event.get_action_strength("up") >= 0.9 or event.get_action_strength("down") >= 0.9:
		var tween := create_tween()
		if event.get_action_strength("up") >= 0.9 :
			tween.tween_property(Scroller,"scroll_vertical",clamp(Scroller.scroll_vertical + 75*3,0,VBoxScores.size.y),1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		if event.get_action_strength("down") >= 0.9 :
			tween.tween_property(Scroller,"scroll_vertical",clamp(Scroller.scroll_vertical - 75*3,0,VBoxScores.size.y),1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func update_scoreboard_version(path : String, version : String) -> void :
	var old_scoreboard : Resource = load(path)
	var new_scoreboard : ScoreBoard = ScoreBoard.new()
	for score : Resource in old_scoreboard.scores :
		var new_score : Score = Score.new()
		new_score.player_name = score.player_name
		new_score.score = score.score if old_scoreboard.version == "1" and score.score <= 40 else score.score*2000
		var date : PackedStringArray = Time.get_date_string_from_system().split("-")
		new_scoreboard.add_score(new_score)
		new_scoreboard.version = "2"
	ResourceSaver.save(new_scoreboard, path)
