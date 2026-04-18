extends Node3D

@onready var base_rot_y := 0.0
@onready var base_rot_z := 0.0
@onready var time := 0.0

func _ready() -> void:
	base_rot_y = rotation.y
	base_rot_z = rotation.z
	
func _physics_process(delta: float) -> void:
	time += delta
	rotation.z = base_rot_z + time * 0.5
	rotation.y = base_rot_y + time * 0.2
	
