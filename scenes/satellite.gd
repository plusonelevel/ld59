class_name Satellite
extends StaticBody3D

@onready var path = $"../.."
@onready var path_follow = $".."
@onready var orbit = $"../../CSGPolygon3D"

@export var speed := 300.0
var target_rotation
var elapsed := 0.0

@export var activated := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(path and path is Path3D and path_follow and path_follow is PathFollow3D, "Satellite must be a child of PathFollow3D!")
	target_rotation = path.rotation.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	path_follow.progress += delta * speed


func rotate_orbit(dir: Enums.RotateDirection) -> void:
	var diff := 0.1 if dir == Enums.RotateDirection.Right else -0.1
	path.rotation.x += diff
	orbit.rotation.x -= diff
	orbit.operation = orbit.operation


func activate() -> void:
	activated = true
	$SatelliteMesh.scale = Vector3(2.0, 2.0, 2.0)
