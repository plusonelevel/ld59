extends Node3D


@export var speed : float
	
func _physics_process(delta: float) -> void:
	rotate_y(delta * speed)
	
