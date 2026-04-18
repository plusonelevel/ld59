extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		if get_window().mode == Window.MODE_FULLSCREEN:
			get_window().mode = Window.MODE_WINDOWED
		else:
			get_window().mode = Window.MODE_FULLSCREEN

	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select_1"):
		Signals.select_satellite.emit(0)
	elif event.is_action_pressed("select_default"):
		Signals.select_planet.emit()
