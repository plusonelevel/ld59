extends Node3D

const MIN_ZOOM_RATIO := 1.0
const MAX_ZOOM_RATIO := 2.0
const ZOOM_STEP = 0.1
@export_range(MIN_ZOOM_RATIO, MAX_ZOOM_RATIO, ZOOM_STEP) var camera_zoom = 1.0
@export_range(1.0, 10.0, 0.1) var camera_sensitivity = 5.0
@export var invert_vertical = false
@export var invert_horizontal = false
@onready var pivot = $Pivot
@onready var cam = $Pivot/Camera3D

@export var focus: Node3D
var distance: float

var planet: Node3D

func _ready() -> void:
	Signals.camera_reset.connect(_on_camera_reset)
	Signals.camera_centered.connect(_on_camera_centered)
	
	pivot.rotate_x(-0.5)
	planet = focus
	distance = 500

func _process(delta: float) -> void:
	position = focus.global_position
	cam.position.z = camera_zoom * distance

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
		camera_zoom = maxf(MIN_ZOOM_RATIO, camera_zoom - ZOOM_STEP)
	elif event.is_action("zoom_out"):
		camera_zoom = minf(MAX_ZOOM_RATIO, camera_zoom + ZOOM_STEP)


func _on_camera_reset() -> void:
	focus = planet
	distance = 500

func _on_camera_centered(node: Node3D) -> void:
	focus = node
	distance = 50
	
