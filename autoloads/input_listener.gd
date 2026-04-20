extends Node

const MIN_SPEED := 1.0
const MAX_SPEED := 10.0
const SPEED_STEP := 1.0

var input_locked := false
var dialogue_active := false
var dialogue_ui: Node = null

func _input(event: InputEvent) -> void:
	if input_locked:
		get_viewport().set_input_as_handled()
		return

	if dialogue_active:
		var next_pressed := false

		if event.is_action_pressed("dialog_progress"):
			next_pressed = true
		elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			next_pressed = true

		if next_pressed and dialogue_ui and dialogue_ui.has_method("next_dialogue_line"):
			dialogue_ui.next_dialogue_line()

		get_viewport().set_input_as_handled()
		return

func _shortcut_input(event: InputEvent) -> void:
	if input_locked or dialogue_active:
		return

	if event.is_action_pressed("toggle_fullscreen"):
		if get_window().mode == Window.MODE_FULLSCREEN:
			get_window().mode = Window.MODE_WINDOWED
		else:
			get_window().mode = Window.MODE_FULLSCREEN
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _unhandled_key_input(event: InputEvent) -> void:
	if input_locked or dialogue_active:
		return

	if event.is_action_pressed("speed_up"):
		var scale = minf(MAX_SPEED, Engine.time_scale + SPEED_STEP)
		Engine.time_scale = scale
		Signals.time_scale_set.emit(scale)
	elif event.is_action_pressed("speed_down"):
		var scale = maxf(MIN_SPEED, Engine.time_scale - SPEED_STEP)
		Engine.time_scale = scale
		Signals.time_scale_set.emit(scale)
