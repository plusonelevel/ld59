class_name Planet
extends StaticBody3D

var discovered := false
@export_range(0, 5, 1) var security_level := 1
var beamed_from: Array[Satellite] = []
var unlocked := false

@export var cam_distance := 1000.0

@onready var mesh: MeshInstance3D = $MeshInstance3D

var satellites: Array[Satellite] = []
var orbits: Array[CSGPolygon3D] = []

func _ready() -> void:
	mesh.hide()

	for sat in get_tree().get_nodes_in_group("satellite"):
		if sat is Satellite and is_ancestor_of(sat):
			satellites.append(sat)

	orbits = find_all_csg_polygons()

	for orbit in orbits:
		orbit.hide()

func find_all_csg_polygons(node: Node = self, result: Array[CSGPolygon3D] = []) -> Array[CSGPolygon3D]:
	for child in node.get_children():
		if child is CSGPolygon3D:
			result.append(child)

		find_all_csg_polygons(child, result)

	return result

func discover() -> void:
	print_debug("Planet %s discovered!" % [name])
	discovered = true
	Signals.planet_discovered.emit(self)
	mesh.show()

	for orbit in orbits:
		orbit.show()

	if security_level <= 0:
		_unlock()

func get_beamed(from: Satellite) -> void:
	if not beamed_from.has(from):
		security_level -= 1
		beamed_from.append(from)
		Signals.planet_beamed.emit(self)

	if security_level <= 0:
		_unlock()

func _unlock() -> void:
	unlocked = true
	Signals.planet_unlocked.emit(self)

func get_satellites() -> Array[Satellite]:
	return satellites
