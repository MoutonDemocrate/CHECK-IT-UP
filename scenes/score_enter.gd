extends Control

@onready var Tabs : TabContainer = $TabContainer

## Onreadys for the name selection
@onready var HBoxName : HBoxContainer = $TabContainer/VBoxContainer/VBoxContainer/HBoxName
@onready var SelectPanel : PanelContainer = $TabContainer/VBoxContainer/VBoxContainer/HBoxSelect/SelectPanel
@onready var SelectLabel : Label = SelectPanel.get_child(0)

## Onreadys for the score print

var char_list : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ☑"
var select_index : int = 0

var playerName : String = ""

func _ready() -> void:
	SelectLabel.text = char_list[select_index]

func _input(event : InputEvent):
	if event.is_action_pressed("up") :
		playerName += char_list[select_index]
		if playerName.length() >= 11 :
			playerName[10] = ''
		update_name()
	
	if event.is_action_pressed("down") :
		if playerName != "":
			playerName = playerName.left(playerName.length()-1)
		update_name()
	
	if event.is_action_pressed("left") or event.is_action_pressed("right") :
		if event.is_action_pressed("left") :
			select_index = (select_index - 1) % char_list.length()
		if event.is_action_pressed("right") :
			select_index = (select_index + 1) % char_list.length()
		if char_list[select_index] == "☑":
			name_entered()
		else :
			SelectLabel.text = char_list[select_index]
	
func update_name() -> void :
	print("Name is \"",playerName,"\".")
	for i in range(0,playerName.length()) :
		HBoxName.get_child(i).get_child(0).text = playerName[i]
	for i in range(playerName.length(), 9) :
		HBoxName.get_child(i).get_child(0).text = ""

func name_entered() -> void :
	pass
