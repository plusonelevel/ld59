extends Node

const MIN_SPEED := 1.0
const MAX_SPEED := 3.0
const SPEED_STEP := 1.0

func _shortcut_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		if get_window().mode == Window.MODE_FULLSCREEN:
			get_window().mode = Window.MODE_WINDOWED
		else:
			get_window().mode = Window.MODE_FULLSCREEN

	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("speed_up"):
		Engine.time_scale = minf(MAX_SPEED, Engine.time_scale + SPEED_STEP)
	elif event.is_action_pressed("speed_down"):
		Engine.time_scale = maxf(MIN_SPEED, Engine.time_scale - SPEED_STEP)
	
