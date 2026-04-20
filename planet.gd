class_name Planet
extends StaticBody3D

var discovered := false

@export var cam_distance := 1000.0
var satellites: Array[Satellite]

func _ready() -> void:
	for sat in get_tree().get_nodes_in_group("satellite"):
		if sat is Satellite and is_ancestor_of(sat):
			satellites.append(sat)
	

func discover() -> void:
	print_debug("Planet %s discovered!" % [name])
	discovered = true
	Signals.planet_discovered.emit(self)


func get_satellites() -> Array[Satellite]:
	return satellites
