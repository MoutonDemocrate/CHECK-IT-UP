extends PanelContainer

func _tween_alpha(a_start : float, a_end : float, duration : float = 0.5):
	$SpeedLinesRectTop._tween_parameter("alpha", a_start, a_end, duration)
