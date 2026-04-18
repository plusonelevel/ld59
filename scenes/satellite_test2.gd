extends MeshInstance3D

@onready var path = $".."
@onready var path_parent = $"../.."
@onready var speed := 800.0
@onready var orbit = $"../../CSGPolygon3D"

func _physics_process(delta: float) -> void:
	path.progress += delta * speed

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("j"):
			path_parent.rotation.x -= 0.1
			orbit.rotation.x += 0.1
			orbit.operation = orbit.operation

	if event.is_action_pressed("k"):
			path_parent.rotation.x += 0.1
			orbit.rotation.x -= 0.1
			orbit.operation = orbit.operation

			
