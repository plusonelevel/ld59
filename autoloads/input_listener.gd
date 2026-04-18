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
		Signals.satellite_selected.emit(0)
	elif event.is_action_pressed("select_2"):
		Signals.satellite_selected.emit(1)
	elif event.is_action_pressed("select_3"):
		Signals.satellite_selected.emit(2)
	elif event.is_action_pressed("select_default"):
		Signals.planet_selected.emit()
	
	if event.is_action_pressed("ui_left"):
		Signals.orbit_rotated.emit(Enums.RotateDirection.Left)
	elif event.is_action_pressed("ui_right"):
		Signals.orbit_rotated.emit(Enums.RotateDirection.Right)
