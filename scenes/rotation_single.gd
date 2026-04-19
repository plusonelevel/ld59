extends MeshInstance3D

@onready var rot_y
@onready var rot_z
@onready var speed = 0.05

func _ready() -> void:
	rot_y = rotation.y
	rot_z = rotation.z
	
	
func _process(delta: float) -> void:
	rotation.y += rot_y + speed * delta
	rotation.z += rot_z + speed * delta
