extends HBoxContainer
class_name ScoreItem

@export var playerName : String = ""
@export_range(0,99999) var score : int = 0
@export_range(0,9999999) var rank : int = 0
@export var date := "??/??/2024"

@onready var RankLabel : Label = $RankLabel
@onready var NameLabel : Label = $NameLabel
@onready var ScoreLabel : Label = $ScoreLabel
@onready var DateLabel : Label = $DateLabel

func _ready() -> void:
	pass

func update() -> void:
	RankLabel.text = "#" + str(rank)
	NameLabel.text = playerName.to_upper()
	ScoreLabel.text = "%05d" % score
	DateLabel.text = date
