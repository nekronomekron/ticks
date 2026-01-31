extends Label

func _process(_delta):
	text = "FPS: %s\nMouse: %s" % [Engine.get_frames_per_second(), get_viewport().get_mouse_position()]
