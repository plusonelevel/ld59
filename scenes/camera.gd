extends Node3D

const MIN_ZOOM_RATIO := 1.0
const MAX_ZOOM_RATIO := 3.0
const ZOOM_STEP = 0.1
@export_range(MIN_ZOOM_RATIO, MAX_ZOOM_RATIO, ZOOM_STEP) var camera_zoom = 1.5
@export_range(1.0, 10.0, 0.1) var camera_sensitivity = 5.0
@onready var pivot = $Pivot
@onready var cam = $Pivot/Camera3D

@export var focus: Node3D
var distance: float

func _ready() -> void:
	Signals.planet_selected.connect(_on_planet_selected)
	Signals.satellite_selected.connect(_on_satellite_selected)
	
	distance = 1000


func _process(_delta: float) -> void:
	position = focus.global_position
	cam.position.z = camera_zoom * distance

func _input(event: InputEvent) -> void:
	if event.is_action("camera_drag") or event.is_action("move_drag"):
		if event.is_pressed():
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseMotion and (Input.is_action_pressed("camera_drag") or Input.is_action_pressed("move_drag")):
		var sensitivity = camera_sensitivity / 10.0 if Input.is_action_pressed("move_drag") else camera_sensitivity
		rotate_y(-event.screen_relative.x * 0.001 * sensitivity)
		pivot.rotate_x(-event.screen_relative.y * 0.001 * sensitivity)
	elif event.is_action("zoom_in"):
		camera_zoom = maxf(MIN_ZOOM_RATIO, camera_zoom - ZOOM_STEP)
	elif event.is_action("zoom_out"):
		camera_zoom = minf(MAX_ZOOM_RATIO, camera_zoom + ZOOM_STEP)


func get_camera_rotation() -> Vector3:
	return cam.global_rotation


func _on_planet_selected(planet: Planet) -> void:
	focus = planet
	distance = planet.cam_distance

func _on_satellite_selected(sat: Satellite) -> void:
	focus = sat
	distance = 100
	
