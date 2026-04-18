class_name Satellite
extends Node3D

@onready var path = $"../.."
@onready var path_follow = $".."
@onready var orbit = $"../../CSGPolygon3D"

@export var speed := 300.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(path and path is Path3D and path_follow and path_follow is PathFollow3D, "Satellite must be a child of PathFollow3D!")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	path_follow.progress += delta * speed


func rotate_orbit(dir: Enums.RotateDirection) -> void:
	var diff = 0.1 if dir == Enums.RotateDirection.Right else -0.1
	path.rotation.x += diff
	orbit.rotation.x -= diff
	orbit.operation = orbit.operation
