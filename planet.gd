class_name Planet
extends StaticBody3D

var discovered := false
@export_range(0, 5, 1) var security_level := 1
var beamed_from: Array[Satellite]
var unlocked := false

@export var cam_distance := 1000.0

@onready var mesh := $MeshInstance3D

var satellites: Array[Satellite]

func _ready() -> void:
	beamed_from = []
	mesh.hide()
	for sat in get_tree().get_nodes_in_group("satellite"):
		if sat is Satellite and is_ancestor_of(sat):
			satellites.append(sat)
	

func discover() -> void:
	print_debug("Planet %s discovered!" % [name])
	discovered = true
	Signals.planet_discovered.emit(self)
	mesh.show()
	
	if security_level <= 0:
		await get_tree().create_timer(1.0).timeout
		_unlock()

func get_beamed(from: Satellite):
	if not beamed_from.has(from):
		security_level -= 1
		beamed_from.append(from)
		Signals.planet_beamed.emit(self)
	if security_level <= 0:
		_unlock()
		

func _unlock():
	unlocked = true
	Signals.planet_unlocked.emit(self)

func get_satellites() -> Array[Satellite]:
	return satellites
