extends MarginContainer
class_name ProgressManager

var total_time : float
var time_left : float

var active : bool = false

@onready var ProgBar : ProgressBar = $ProgressBar
@onready var TimeLabel : Label = $CenterContainer/TimeLabel

## Color gradient used by the progress bar
@export var gradient : GradientTexture1D

func _process(delta):
	if active :
		TimeLabel.text = str(snappedf(time_left, 0.01))
		ProgBar.value = (time_left/total_time) * 100
		time_left -= delta
		
		var stylebox := StyleBoxFlat.new()
		stylebox.bg_color = gradient.gradient.sample((time_left/total_time))
		ProgBar.add_theme_stylebox_override("fill",stylebox)
		
		if time_left <= 0 :
			time_left = 0.0
			active = false
			$"../..".game_over()

func initialise(time : float) -> void :
	total_time = time
	time_left = total_time
	TimeLabel.text = str(snappedf(time_left, 0.01))
	ProgBar.value = (time_left/total_time) * 100

func start(time : float = 0.0) -> void :
	if time != 0.0 :
		initialise(time)
	active = true

func stop() -> void :
	active = false
