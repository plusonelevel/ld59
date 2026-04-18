extends Node3D

const MAX_ZOOM = 500
const MIN_ZOOM = 1500
const ZOOM_STEP = 5
@export_range(MAX_ZOOM, MIN_ZOOM, ZOOM_STEP) var camera_zoom = 1000
@export_range(1.0, 10.0, 0.1) var camera_sensitivity = 5.0
@export var invert_vertical = false
@export var invert_horizontal = false
@onready var pivot = $Pivot
@onready var cam = $Pivot/Camera3D

@export var focus: Node3D

func _ready() -> void:
	pivot.rotate_x(-0.5)

func _input(event: InputEvent) -> void:
	if event.is_action("camera_drag"):
		if event.is_pressed():
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseMotion and Input.is_action_pressed("camera_drag"):
		rotate_y(event.screen_relative.x * 0.001 * camera_sensitivity * (1 if invert_horizontal else -1))
		pivot.rotate_x(event.screen_relative.y * 0.001 * camera_sensitivity * (1 if invert_horizontal else -1))
	elif event.is_action("zoom_in"):
		camera_zoom = maxf(MAX_ZOOM, camera_zoom - ZOOM_STEP)
	elif event.is_action("zoom_out"):
		camera_zoom = minf(MIN_ZOOM, camera_zoom + ZOOM_STEP)

func _process(delta: float) -> void:
	cam.position.z = camera_zoom
