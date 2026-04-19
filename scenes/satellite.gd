class_name Satellite
extends StaticBody3D

@onready var path = $"../.."
@onready var path_follow = $".."
@onready var orbit = $"../../CSGPolygon3D"
@onready var hack_fx = $Hack
@onready var LRscan_fx = $Scan_LR
@onready var SRscan_fx = $Scan_SR
@onready var LRhack_fx = $LRhack

@export var sat_model : PackedScene

@export var speed := 300.0
var target_rotation: Vector3
var target_lock: Variant = null
var elapsed := 0.0
var sat_abilities = false

@export var activated := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var model_instance = sat_model.instantiate()
	add_child(model_instance)
	
	assert(path and path is Path3D and path_follow and path_follow is PathFollow3D, "Satellite must be a child of PathFollow3D!")
	target_rotation = rotation
	if activated:
		$Sprite3D.hide()
		$Satellite.show()
	else:
		$Sprite3D.show()
		$Satellite.hide()
	
	


var progress := 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	path_follow.progress += delta * speed
	
	if rotation.is_equal_approx(target_rotation):
		progress = 0.0
	else:
		if target_lock:
			look_at(target_lock.global_position)
		else:
			progress += delta / 1000.0
			rotation = rotation.lerp(target_rotation, progress)


func activate() -> void:
	activated = true
	$Sprite3D.hide()
	$Satellite.show()


func hack_fail():
	hack_fx.emitting = true
	await get_tree().create_timer(1.0).timeout
	hack_fx.emitting = false
	
func hack(target: Satellite):
	target_lock = target
	hack_fx.emitting = true
	await get_tree().create_timer(3.0).timeout
	hack_fx.emitting = false
	target_lock = null
		

func set_target_rotation(new_rotation: Vector3) -> void:
	target_rotation = new_rotation
