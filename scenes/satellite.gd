class_name Satellite
extends StaticBody3D

@onready var path = $"../.."
@onready var path_follow = $".."
@onready var orbit = $"../../CSGPolygon3D"

@export var speed := 300.0
var target_rotation: Vector3
var elapsed := 0.0

@export var activated := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(path and path is Path3D and path_follow and path_follow is PathFollow3D, "Satellite must be a child of PathFollow3D!")
	target_rotation = rotation
	if activated:
		$Sprite3D.hide()
		$satellite.show()
	else:
		$Sprite3D.show()
		$satellite.hide()

var progress := 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	path_follow.progress += delta * speed
	
	if rotation.is_equal_approx(target_rotation):
		progress = 0.0
	else:
		progress += delta / 1000.0
		rotation = rotation.lerp(target_rotation, progress)


func activate() -> void:
	activated = true
	$Sprite3D.hide()
	$satellite.show()

func set_target_rotation(new_rotation: Vector3) -> void:
	target_rotation = new_rotation

func hack() -> void:
	pass

func ping() -> void:
	pass
	
