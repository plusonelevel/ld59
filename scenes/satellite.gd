class_name Satellite
extends Node3D

@export var speed := 0.03

var init_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_pos = position
	position = Vector3.ZERO
	$Satellite.position = init_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	rotate_y(speed * delta)

func get_satellite() -> StaticBody3D:
	return $Satellite
