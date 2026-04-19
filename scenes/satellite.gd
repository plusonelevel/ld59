class_name Satellite
extends StaticBody3D

@onready var path = $"../.."
@onready var path_follow = $".."
@onready var orbit = $"../../CSGPolygon3D"
@onready var hack_fx = $Hack
@onready var LRscan_fx = $Scan_LR
@onready var SRscan_fx = $Scan_SR
@onready var LRhack_fx = $LRhack

@export var speed := 300.0
var target_rotation: Vector3
var elapsed := 0.0
var sat_abilities = false

@export var activated := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(path and path is Path3D and path_follow and path_follow is PathFollow3D, "Satellite must be a child of PathFollow3D!")
	target_rotation = rotation
	if activated:
		$Sprite3D.hide()
		$Satellite.show()
	else:
		$Sprite3D.show()
		$Satellite.hide()
		
	Signals.connect("ability1",_ability1)
	Signals.connect("ability2",_ability2)
	Signals.connect("ability3",_ability3)
	Signals.connect("ability4",_ability4)
	Signals.connect("current_location",_location_change)

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
	$Satellite.show()

func _location_change(location):
	if location == "Planet":
		sat_abilities = false
		Signals.toggle_abilities.emit(sat_abilities)
	else:
		sat_abilities = true
		Signals.toggle_abilities.emit(sat_abilities)

func _ability1():
	if SRscan_fx.emitting == false:
		SRscan_fx.emitting = true
	else:
		SRscan_fx.emitting = false
	
func _ability2():
	if LRscan_fx.emitting == false:
		LRscan_fx.emitting = true
	else:
		LRscan_fx.emitting = false

func _ability3():
	if hack_fx.emitting == false:
		hack_fx.emitting = true
	else:
		hack_fx.emitting = false
		
func _ability4():
	if LRhack_fx.emitting == false:
		LRhack_fx.emitting = true
	else:
		LRhack_fx.emitting = false
		

func set_target_rotation(new_rotation: Vector3) -> void:
	target_rotation = new_rotation

func hack() -> void:
	pass

func ping() -> void:
	pass
	
