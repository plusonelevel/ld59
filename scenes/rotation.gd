extends Node3D


@export var y_speed : float
@export var z_speed : float
@export var x_speed : float
	
func _physics_process(delta: float) -> void:
	rotate_y(delta * y_speed)
	rotate_z(delta * z_speed)
	rotate_x(delta * x_speed)
	
