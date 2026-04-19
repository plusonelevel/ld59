extends Node

const MIN_SPEED := 1.0
const MAX_SPEED := 3.0
const SPEED_STEP := 1.0

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
		
	
	elif event.is_action_pressed("speed_up"):
		Engine.time_scale = minf(MAX_SPEED, Engine.time_scale + SPEED_STEP)
	elif event.is_action_pressed("speed_down"):
		Engine.time_scale = maxf(MIN_SPEED, Engine.time_scale - SPEED_STEP)
